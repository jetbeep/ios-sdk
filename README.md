# Hardware setup #
https://drive.google.com/drive/u/1/folders/1exPvE0fJYBYEf-XRj5r4i4IQqMalLuma

# Steps for project setup: #
### add our pod: ###

`pod 'JetBeepFramework'`

call 

`pod install`

`pod update` 

in your terminal

Open your project workspace.

#### Select tab:  Capabilities

Scroll to `Background Modes`:

Switch on it and mark as selcted next bars:
>- Location updates,
>- Uses Bluetooth LE accessories
>- Acts as a Bluestooth LE accessory - switch on

Open ***Info.plist*** -
Add ***Required background modes*** - key with description, somethings like: __App shares data using CoreBluetooth__

Add `import JetBeepFramework` at all files where you are using our SDK.
Do the same for the next keys:
>- NSBluetoothPeripheralUsageDescription
>- NSBluetoothPeripheralUsageDescription 
>- NSLocationAlwaysAndWhenInUseUsageDescription 
>- NSLocationWhenInUseUsageDescription 

## Now you are ready to go! 

Fields that a requierd for __anonymous__ type of registration you can impolement them at your `AppDelegate`

___Select dev server for tests!___

    JetBeep.shared.devServer = true
    JetBeep.shared.registrationType = .anonymous
    JetBeep.shared.setup(appName: your app name that you can request from our side, appTokenKey: your app token key that you can request from our side)
    JetBeep.shared.serviceUUID = your app serviceUUID that you can request from our side

Instance of barcode handler protocol, it will be used when you will provide barcodes

`JetBeep.shared.barcodeRequestHandler = barcodeHandler`

Handle result on your place to track is barcodes transfering moved succeed or not
`barcodeHandler.delegate = self`

Add location manager

`locationManager.delegate = self
locationManager.requestAlwaysAuthorization()`

Add peripheral Manager

`peripheralManager = CBPeripheralManager(delegate: self, queue: nil)`

Working implementation you can find at our file: `JetBeepAnonymouseController.swift`


Fields that a requierd for __registered__ type of registration you can impolement them at your `AppDelegate`
___Select dev server for tests!___

    JetBeep.shared.devServer = true
    JetBeep.shared.registrationType = .registered
    JetBeep.shared.setup(appName: your app name that you can request from our side, appTokenKey: your app token key that you can request from our side)
    JetBeep.shared.serviceUUID = your app serviceUUID that you can request from our side

___Don't forget to fetch data from server side with set of shop id's, merchant id's, etc___

```
JetBeep.shared.sync()
            .then {
                //Add your code if needed
            }.catch { _ in
                //Add your code if needed
        }
```

Add location manager

`locationManager.delegate = self
locationManager.requestAlwaysAuthorization()`

Add peripheral Manager

`peripheralManager = CBPeripheralManager(delegate: self, queue: nil)`

Working implementation you can find at our file: `JetBeepRegisteredController.swift`

To receive events of entry and exit into the zone of beacon add a listener and subscribe on it:
```
locationsCallbackId = JBLocations.shared.subscribe { event in
            switch event {
            case .MerchantEntered(let merchant):
                Log.d("Entered merchant: \(merchant.name)")
            case .ShopEntered(let shop, _):
                Log.d("Entered shop: \(shop.name)")
            case .ShopExited(let shop, _):
                Log.d("Exited shop: \(shop.name)")
            case .MerchantExited(let merchant):
                Log.d("Exited merchant: \(merchant.name)")
            }
        }
```	
##Notifications
To receive push notifications, subscribe to `NotificationDispatcher`. Inside you can add a logic for different types of notifications. Full realization of `NotificationController` see in the test application. 
### Important 
All notifications setup at admin console and shows acording to rules setuped there!

`NotificationModel` - containse next fields.

```
    public let id: String - unique id
    public let merchantId: Int 
    public let shopId: Int?
    public let isSilentPush: Bool
    public let title: String
    public let subtitle: String
	public var merchant: Promise<Merchant?>
	public var info: Promise<NotificationInfo>
```

`NotificationInfo` - containes all things that you needed in general to show notification for user

```
    public let id: String
    public let title: String - setup on admin side
    public let subtitle: String - setup on admin side
    public let iconPath: String? - an icon of merchant
    public let isSilentPush: Bool - setup on admin side 
```

##Loyalty
If you are using registered type of app, you can subscribe for loyalties next way:

```
loyaltyCallbackId = JBBeeper.shared.subscribe { event in
            switch event {
            case .LoyaltyNotFound(_):
                Log.w("loyalty not found")
            case .LoyaltyTransferred(_, _, _, _):
                Log.i("loyalty transferred")
            default:
                Log.w("unhandler event")
            }
        }
```

example at `JetBeepRegisteredController`

##Vending
You can get instances of VendingDevice related to custom merchant using next action 

```VendingController.shared.filteredDevices(by: merchant.id)```
 
Yòu'll get list of device near you that related to custom merchant.

###Listen devices ststus changes

```
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

###Connect & disconnect
`VendingController.shared.connectWithRetry(to: device)` - return promise as a result, that shows is action was success or not.

`VendingDevice`
Have a next propertyes:

```
    public let peripheral: CBPeripheral - identifers from OS
    public internal(set) var rawState: UInt32 - current state of device
    public let shop: Shop 
    public let merchant: Merchant
    public internal(set) var lastSeen: Date
    public internal(set) var connectionState: VendingConnectionState
```


`VendingConnectionState` have a next types:

	case notConnected
	case connecting
	case connected


We can be connected only for one device at the same time, that's why you don't specify in any kind disconnect

`VendingController.shared.disconnect()` - return promise as a result, that shows is action was success or not.

***Note: During active connection all other devices become non-connectable.***

###Receiving events from devices
You need to receive events for interact with device after connection. In order to open a session and initiate payment, we need to receive events from the device. To do this, we need to subscribe to events:

```
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

When closing, don't forget to unsubscribe and stop the beeper:

`JBBeeper.shared.unsubscribe(eventSubscribeID)`

###Testing
***IMPORTANT NOTE***: Before testing ensure that your devices is configured for VENDING-type merchants. Please double-check them.
 
