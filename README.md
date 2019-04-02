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

Add location manager

`locationManager.delegate = self
locationManager.requestAlwaysAuthorization()`

Add peripheral Manager

`peripheralManager = CBPeripheralManager(delegate: self, queue: nil)`

Working implementation you can find at our file: `JetBeepRegisteredController.swift`


