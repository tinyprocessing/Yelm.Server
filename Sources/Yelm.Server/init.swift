// Server File.swift - contains object class to work with server api.yelm.io

//libs

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
    public var user : User =  User()
    public var items : Items =  Items()
    public var news : News =  News()
    public var basket : Basket =  Basket()
    public var cache : RealmCache = RealmCache()
    public var orders : Orders = Orders()
    public var promocode : Promocode = Promocode()
   

    
    /// Start Server Class
    /// - Parameters:
    ///   - platform: platform String
    ///   - position: position lat;lon in String
    ///   - completionHandlerStart: get back when server ready
    public func start(platform : String, position : String, completionHandlerStart: @escaping (_ success:Bool) -> Void){
        self.settings.platform = platform
        self.settings.position = position
        
        
        let user = UserDefaults.standard.string(forKey: "USER") ?? ""
        if (user != ""){
            ServerAPI.user.username = user
        }
        
        DispatchQueue.main.async {
            completionHandlerStart(true)
        }
        
        
    }
    

}


