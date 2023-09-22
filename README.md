
# Jetbeep Solution Integration Guideline SDK 1.x

## Hardware setup

[Hardware setup documentation](https://drive.google.com/drive/u/1/folders/1exPvE0fJYBYEf-XRj5r4i4IQqMalLuma)

## Project Setup Steps

### Pod integration

Add `pod 'JetBeepFramework'` to your Podfile.

At the end of the Podfile, add:

```ruby
post_install do |installer|
  xcode_base_version = `xcodebuild -version | grep 'Xcode' | awk '{print $2}' | cut -d . -f 1`

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'

      if config.base_configuration_reference && Integer(xcode_base_version) >= 15
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      end

    end
  end
end

```

**Hot fix for Xcode 15:**
Xcode 15 bring new breaking changes. More details about them you can find [here](https://developerinsider.co/fix-xcode-15-dt_toolchain_dir-cannot-be-used-to-evaluate-library_search_paths-use-toolchain_dir-instead/)


**Hot fix for Xcode 14.3:**

Xcode 14.3 introduced breaking changes. To resolve these issues, follow the temporary solution provided in this [Stack Overflow](https://stackoverflow.com/a/75924853/1810564) post. When unzipping the missing files, ensure they are placed in the correct folder, and move them from the subfolder to the 'arc' folder.

Run the following commands:

`pod install`

`pod update`

Open your project *workspace*.

### Project Internal Integration

Open the project using Xcode.

### Select tab: *Capabilities*

Scroll to `Background Modes`:

Enable the following options:

- Location updates
- Uses Bluetooth LE accessories
- Acts as a Bluetooth LE accessory - switch ON
- Open Info.plist file
- Add Required background modes
- As a description of this mode, you could use something like: `App shares data using CoreBluetooth ...`

Add `import JetBeepFramework` to all files where you are using the SDK.

Do the same for the following keys:

- `NSBluetoothPeripheralUsageDescription`

## Code implementation

Add at `AppDelegate`

***Select the dev server for tests!***

`appName` - App name ID generated on our backend side;
`appToken` - App token ID generated on our backend side;
`serviceUUID` - App serviceUUID generated on our backend side;

``` swift
    JetBeep.shared.serverType = .prod
    JetBeep.shared.registrationType = .anonymous
    JetBeep.shared.setup(appName: appNameKey, appTokenKey: appToken)
    JetBeep.shared.serviceUUID = serviceUUID
```

We expect an instance of the barcode handler protocol.

`JetBeep.shared.barcodeRequestHandler = barcodeHandler`

To observe the result of barcode transferring, you should implement a delegate.

`barcodeHandler.delegate = self`

## Personalized Offers and Notifications

The Jetbeep SDK now supports personalized offers and notifications based on users' phone numbers or loyalty card numbers.

### Assigning User Numbers

To enable personalized offers and notifications, assign an array of strings containing phone numbers or loyalty card numbers to the `Jetbeep.shared.userNumbers` property:

```swift
Jetbeep.shared.userNumbers = ["380007890000"]
```

### Usage

Once you have assigned user numbers to `Jetbeep.shared.userNumbers`, the SDK will automatically start providing personalized offers and notifications to the specified users at the next fetching request of `sync` function.

Please ensure that your application has obtained the necessary permissions from users to use their phone numbers or loyalty card numbers for this purpose.

### Example

Here's an example of how to set up personalized offers and notifications in your application:

```swift
// Obtain user's phone number or loyalty card number
let userPhoneNumber = "380007890000"

// Assign the number to Jetbeep.shared.userNumbers
Jetbeep.shared.userNumbers = [userPhoneNumber]

// Update offers and notifications
JetBeep.shared.sync()
```

// The SDK will now provide personalized offers and notifications for the specified user

### Bluetooth Flow implementation

`JBLocations.shared.startMonitoringFlow(.bluetooth))`

You can find a working implementation in our file:

`JetBeepAnonymouseController.swift`

### Mange events from device

To receive events of entering and exiting the area of the Jetbeep device, add a listener:

```swift
locationsCallbackId = JBLocations.shared.subscribe { event in
            switch event {
            case .merchantEntered(let merchant, let shop):
                Log.d("Entered merchant: \(merchant.name) \(shop.name)")
            case .shopEntered(let shop, _):
                Log.d("Entered shop: \(shop.name)")
            case .shopExited(let shop, _):
                Log.d("Exited shop: \(shop.name)")
            case .merchantExited(let merchant):
                Log.d("Exited merchant: \(merchant.name)")
            }
        }
```

### Notifications

The Jetbeep platform provides a mechanism for setting custom user notifications on entering a specific shop or merchant and managing them. To receive push notifications, subscribe to `NotificationDispatcher`. Inside, you can add logic for different types of notifications. See the full implementation of `NotificationController` in the test application.

### Important

All notifications are set up in the admin console and are shown according to the rules there!

`NotificationModel` contains the following fields.

```swift
    public let id: String - unique id
    public let merchantId: Int 
    public let shopId: Int?
    public let isSilentPush: Bool
    public let title: String
    public let subtitle: String
    public var merchant: Promise<Merchant?>
    public var info: Promise<NotificationInfo>
```

`NotificationInfo` contains all the necessary information to show a notification to the user.

```swift
    public let id: String - auto generated
    public let title: String - setup on admin side
    public let subtitle: String - setup on admin side
    public let iconPath: String? - an icon of merchant
    public let isSilentPush: Bool - setup on admin side 
```

## Vending

We have separate, detailed documentation with a step-by-step implementation of the vending flow. Therefore, in this document, we provide only common classes and methods.

First, start the vending flow:

`VendingController.shared.start()`

You can get instances of `VendingDevice` related to a specific merchant by feeding the merchant ID to the filtering method:

`VendingController.shared.filteredDevices(by: merchant.id)`

As a result, you'll get a list of devices near you related to a specific merchant.

### Listen to Device Status Changes

```swift
eventSubscribeID = VendingController.shared.subscribe(filter: merchant.id) { [weak self] event in
        guard let strongSelf = self else { return }
        guard !strongSelf.isConnecting else { return }
        switch event {
            case .found, .lost, .stateChanged:
                strongSelf.updateButtonState()
            default:
                break
            }
        }
```

### Connect & Disconnect to a Vending Device

To connect to one of the found and free devices, use the following method:

`VendingController.shared.connectWithRetry(to: device)` - This method returns a promise that notifies whether the action was successful or not.

`VendingDevice`

```swift
    public let peripheral: CBPeripheral - id from OS
    public internal(set) var rawState: UInt32 - current state of device
    public let shop: Shop 
    public let merchant: Merchant
    public internal(set) var lastSeen: Date
    public internal(set) var connectionState: VendingConnectionState
```

`VendingConnectionState` has the following types:

```swift
    case notConnected
    case connecting
    case connected
```

A mobile device can connect to only one vending device at a time. That's why you don't specify an ID in the disconnect method.

`VendingController.shared.disconnect()` - This method returns a promise that notifies whether the action was successful or not.

***Note: During an active connection, all other devices become non-connectable.***

### Receiving Events from Devices

You need to receive events to interact with the device after connecting. To open a session and initiate payment, we need to receive events from the device. Subscribe to events as follows:

```swift
eventSubscribeID = JBBeeper.shared.subscribe { event in
    switch event {
        case BluetoothTurnedOff
        case ConnectionEstablished
        case SessionClosed 
        case WaitingForConnection
        case LoyaltyTransferred(Shop, Merchant, Loyalty, UInt32?)
        case LoyaltyNotFound(Shop, Merchant)
        case PaymentInitiated(Shop, Merchant, PaymentRequest)
        case PaymentInProgress(Shop, Merchant, PaymentRequest)
        case PaymentWaitingConfirmation(Shop, Merchant, PaymentRequest)
        case PaymentSuccessful(Shop, Merchant, PaymentRequest)
        case PaymentTokenInitiated(Shop, Merchant, PaymentRequest)
        case PaymentTokeInProgress(Shop, Merchant, PaymentRequest)
        case PaymentTokenSuccessful(Shop, Merchant, PaymentRequest)
        case PaymentCanceled(Shop, Merchant, PaymentRequest)
        case PaymentFailed(PaymentError, Shop, Merchant, PaymentRequest)
           }
```

When you want to finish the flow, don't forget to unsubscribe and stop the beeper:

`JBBeeper.shared.unsubscribe(eventSubscribeID)`

### Testing

***IMPORTANT NOTE:*** Before testing, ensure that your devices are configured for VENDING-type merchants. Please double-check them.
