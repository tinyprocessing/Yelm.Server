// Server File.swift - contains object class to work with server api.yelm.io

//libs
import DeviceKit
import Alamofire
import SwiftyJSON
import Combine
import SwiftUI
import Foundation

//init class API
public let ServerAPI: Server = Server()

//main class API
open class Server: ObservableObject, Identifiable {
    public var id: Int = 0
    public var system : System = System()
    public var settings : Settings =  Settings()
    public var items : Items =  Items()
    
    
    /// Start Server Class
    /// - Parameters:
    ///   - platform: platform String
    ///   - position: position lat;lon in String
    ///   - completionHandlerStart: get back when server ready
    public func start(platform : String, position : String, completionHandlerStart: @escaping (_ success:Bool) -> Void){
        self.settings.platform = platform
        self.settings.position = position
        
        DispatchQueue.main.async {
            completionHandlerStart(true)
        }
    }
    

}


