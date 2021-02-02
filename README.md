## ## Start SDK

How to use the SDK to create applications based on Yelm Media. 

Thanks to our development you can create a commercial application and manage it through a panel at beta.yelm.io 

## To get started, configure the server operation

Use the start method and pass your platform and user position. The platform is your internal application identifier, the position is passed in the form of coordinates to determine the availability of goods and this or that position.

```swift
ServerAPI.start(platform: "5fd33466e17963.29052139", position: position) {
  (result) in

  // result - Returns a Bool - if everything was successful
  
}
```

Transmit the position strictly in parameter format - as shown in the example

```swift
let position = UserDefaults.standard.string(forKey: "SELECTED_SHOP_POINTS") ?? "lat=0&lon=0"
```

To work with the SDK during testing - we recommend using debug - toggle its state and you can see what sends

```swift
ServerAPI.settings.debug = false
```

## Obtaining the settings of the application

To get the application settings - initialize the get_settings method after a successful SDK start 

```swift
ServerAPI.settings.get_settings {
    (load) in
    if (load) {
      // Here you can use the resulting settings
    }
}
```

What settings do we have ?

```swift
public var theme : String = "" // HEX color of app 
public var foreground : String = "" // HEX color for the text on top of the theme
public var symbol : String = "" // Currency sign for your region
public var currency : String = "" // Currency code for your region
public var debug : Bool = false // You know.
```

## User registration in the system

To register a user, use the registration method. This method will give you a unique user each time you access it - save his login for future accesses.

```swift
ServerAPI.user.registration {
    (load, user) in
    if (load) {
        // user 
        UserDefaults.standard.set(user, forKey: "USER")
    }
}
```

For the rest of the data, see wiki page

