
# Jetbeep solution integration guideline

## Hardware setup

[Hardware setup documentation](https://drive.google.com/drive/u/1/folders/1exPvE0fJYBYEf-XRj5r4i4IQqMalLuma)

## Steps for project setup

### pod integration

Add `pod 'JetBeepFramework'` at your `Podfile`

```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
```

call in your terminal

`pod install`

`pod update`

Open your project workspace.

### Project internal integration

Open project via Xcode

### Select tab: *Capabilities*

Scroll to `Background Modes`:

Open it and mark as `selected` next bars:

> - Location updates
> - Uses Bluetooth LE accessories
> - Acts as a Bluetooth LE accessory - switch `ON`

- Open `Info.plist` file
- Add `Required background modes`
- as a description of this mode, could be something like: `App shares data using CoreBluetooth ...`

Add `import JetBeepFramework` at all files where you are using our SDK.

Do the same for the next keys:

> - NSBluetoothPeripheralUsageDescription

*The next 2 markers should add if you are using location flow for our beacon detection. Deprecated.*

> - NSLocationAlwaysAndWhenInUseUsageDescription
> - NSLocationWhenInUseUsageDescription

## Code implementation

### Anonymous registration flow

Add at `AppDelegate`

***Select dev server for tests!***

`appName` - app name id generated on our backend side;
`appToken` - app token id generated on our backend side;
`serviceUUID` - app serviceUUID generated on our backend side;

``` swift
    JetBeep.shared.serverType = .prod
    JetBeep.shared.registrationType = .anonymous
    JetBeep.shared.setup(appName: appNameKey, appTokenKey: appToken)
    JetBeep.shared.serviceUUID = serviceUUID
```

From our side, we are expecting an instance of barcode handler protocol.

`JetBeep.shared.barcodeRequestHandler = barcodeHandler`

To observe the result of barcode transferring, you should apply a delegate implementation.

`barcodeHandler.delegate = self`

### Location flow implementation

Add location manager

```swift
locationManager.delegate = self
locationManager.requestAlwaysAuthorization()
```

Add peripheral Manager

`peripheralManager = CBPeripheralManager(delegate: self, queue: nil)`

Start `location flow`

`JBLocations.shared.startMonitoringFlow(.location))`

### Bluetooth flow implementation

`JBLocations.shared.startMonitoringFlow(.bluetooth))`

Working implementation you can find at our file:

`JetBeepAnonymouseController.swift`

### Registered registration flow

Add at `AppDelegate`

***Select dev server for tests!***

`appName` - app name id generated on our backend side;
`appToken` - app token id generated on our backend side;
`serviceUUID` - app serviceUUID generated on our backend side;

``` swift
    JetBeep.shared.serverType = .production
    JetBeep.shared.registrationType = .registered
    JetBeep.shared.setup(appName: appNameKey, appTokenKey: appToken)
    JetBeep.shared.serviceUUID = serviceUUID
```

- Don't forget to fetch data from the server-side with a set of shops, merchants, etc.

### Location flow implementation (registered)

Add location manager

```swift
locationManager.delegate = self
locationManager.requestAlwaysAuthorization()
```

Add peripheral Manager

`peripheralManager = CBPeripheralManager(delegate: self, queue: nil)`

Start `location flow`

`JBLocations.shared.startMonitoringFlow(.location))`

### Bluetooth flow implementation (registered)

`JBLocations.shared.startMonitoringFlow(.bluetooth))`

Working implementation you can find at our file: `JetBeepRegisteredController.swift`

```swift
JetBeep.shared.sync()
            .then {
                //Add your code if needed
            }.catch { _ in
                //Add your code if needed
        }
```

### Mange events from device

To receive events of entering and exit into the area of the jetbeep device, add a listener on it:

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

Jetbeep platform gives you a mechanism for setting custom user notifications on entering a custom shop or merchant and managing them.
To receive push notifications, subscribe at `NotificationDispatcher`. Inside you can add logic for different types of notifications. The full realization of `NotificationController` sees in the test application.

### Important

All notifications are set up at the admin console and show according to rules there!

`NotificationModel` - contains next fields.

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

`NotificationInfo` - contains all things that you needed, in general, to show notification for user

```swift
    public let id: String - auto generated
    public let title: String - setup on admin side
    public let subtitle: String - setup on admin side
    public let iconPath: String? - an icon of merchant
    public let isSilentPush: Bool - setup on admin side 
```

### Loyalty

If you are using a registered type of app, you can subscribe for getting loyalties in a next way:

```swift
loyaltyCallbackId = JBBeeper.shared.subscribe { event in
            switch event {
            case .LoyaltyNotFound(_):
                Log.w("loyalty not found")
            case .LoyaltyTransferred(_, _, _, _):
                Log.i("loyalty transferred")
            default:
                Log.w("unknown event")
            }
        }
```

e.g. at `JetBeepRegisteredController`

## Vending

We have separated detailed documentation with the step-by-step implementation of vending flow. Therefore, in this document, we provide only common classes and methods.

First of all, you should start vending flow:
`VendingController.shared.start()`

You can get instances of `VendingDevice` related to the custom merchant feeding merchant id to the filtering method:


```VendingController.shared.filteredDevices(by: merchant.id)```

As a result, you'll get a list of devices near you related to a custom merchant.

### Listen devices status changes

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

### Connect & disconnect to a vending device

To connect at one of the founded and free devices, you can use the next method:

`VendingController.shared.connectWithRetry(to: device)` - This method return promise, as a result, and notify is action was a success or not.

`VendingDevice`

```swift
    public let peripheral: CBPeripheral - id from OS
    public internal(set) var rawState: UInt32 - current state of device
    public let shop: Shop 
    public let merchant: Merchant
    public internal(set) var lastSeen: Date
    public internal(set) var connectionState: VendingConnectionState
```

`VendingConnectionState` have a next types:

```swift
    case notConnected
    case connecting
    case connected
```

Mobile can connect only to one vending device simultaneously. So that's why you don't specify id at disconnect method.

`VendingController.shared.disconnect()` -This method return promise, as a result, and notify is action was a success or not.

***Note: During active connection all other devices become non-connectable.***

### Receiving events from devices

You need to receive events for interact with device after connection. In order to open a session and initiate payment, we need to receive events from the device. To do this, you need to subscribe to events:

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

When you want to finish flow, don't forget to unsubscribe and stop the beeper:

`JBBeeper.shared.unsubscribe(eventSubscribeID)`

### Testing

***IMPORTANT NOTE***: Before testing ensure that your devices is configured for VENDING-type merchants. Please double-check them.
