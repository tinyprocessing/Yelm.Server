//
//  File.swift
//  
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON
import DeviceKit


open class System: ObservableObject, Identifiable {
    public var id: Int = 0
    public let systemVersion = Device.current.systemVersion!
    public let systemName = Device.current.systemName!
    public let model =  Device.current.model!
    public let batteryLevel = String(Device.current.batteryLevel!)
    public let batteryState = String((Device.current.batteryState?.description)!)
    public let cameras = "\(Device.current.cameras)"
    public let safeDescription  = "\(Device.current.safeDescription)"
    public let diagonal  = "\(Device.current.diagonal)"
    public let screenBrightness  = "\(Device.current.screenBrightness)"
    public let name = "\(Device.current.name ?? "")"
    public let supportsWirelessCharging = "\(Device.current.supportsWirelessCharging)"
    
    public func data_string() -> String {
        let data = JSON([
            "systemVersion": systemVersion,
            "systemName": systemName,
            "model": model,
            "batteryLevel": batteryLevel,
            "batteryState": batteryState,
            "cameras": cameras,
            "safeDescription": safeDescription,
            "diagonal": diagonal,
            "screenBrightness": screenBrightness,
            "name": name,
            "supportsWirelessCharging": supportsWirelessCharging,
            ])

        let data_string = data.rawString()
        
        return data_string!
    }
    
  
}
