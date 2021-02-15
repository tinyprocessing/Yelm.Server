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
import SystemConfiguration


let version : String = "3.0"


public class Settings: ObservableObject, Identifiable {
    public var id: Int = 0
    var domain : String = "https://rest.yelm.io/api/"
    var domain_beta : String = "https://dev.yelm.io/api/mobile/"
    public var position : String = ""
    var platform : String = ""
    public var debug : Bool = true
    
//    Settings for application from server
    public var deliverly : Bool = false
    public var takeoff : Bool = false
    public var payments : Bool = false
    public var currency : String = ""
    public var symbol : String = ""
    
//    colors
    public var theme : String = ""
    public var foreground : String = ""
    
    public var shop_id : Int = 0
    
    public var public_id : String = ""
    public var deliverly_time : String = ""
    public var deliverly_price : Float = 0
    
    
    public var news_block_title : String = "Давай дружить!"
    public var order_minimal_price : Float = 300
    public var order_free_delivery_price : Float = 1500
    

    /// Get url to connect rest api
    /// - Parameter method: Method Name - example m-application
    /// - Returns: Ready string
    
    public func set_position(point: String) {
        self.position = point
    }
    
    func url(method: String, dev: Bool = false) -> String {
        var url : String = ""
        if (Locale.current.regionCode != nil && Locale.current.languageCode != nil){
            
            if (dev == false){
                url = self.domain
            }else{
                url = self.domain_beta
            }
           
            url += method
            url += "?version=\(version)&region_code=\(Locale.current.regionCode!)&language_code=\(Locale.current.languageCode!)&platform=\(self.platform)"
            if (self.position == ""){
                url += "&lat=0&lon=0"
            }else{
                url += ("&"+position)
            }
          
            
        }else{

            if (dev == false){
                url = self.domain
            }else{
                url = self.domain_beta
            }
            
            url += method
            url += "?version=\(version)&region_code=US&language_code=en&platform=\(self.platform)"
            if (self.position == ""){
                url += "&lat=0&lon=0"
            }else{
                url += ("&"+position)
            }
            
        }
        
        if (self.debug){
            print(url)
        }
        return url
    }
    
    
    
    /// Get settings from server for platform
    public func get_settings(completionHandlerSettings: @escaping (_ success:Bool) -> Void){
        
        if (ServerAPI.settings.internet()){
            AF.request(self.url(method: "application", dev: true)).responseJSON { (response) in
            if (response.value != nil) {
                let json = JSON(response.value!)
                if (json.count > 0){
                    if (self.debug){
                        print(json)
                    }
                    
                    
                    let json_string_cache = json.rawString()
                    
                    ServerAPI.cache.cache_items(value: json_string_cache!, name: "settings")
                    
                    
                    let settings = json["settings"]

//                    Setup currency
                    ServerAPI.objectWillChange.send()
                    self.currency = json["currency"].string!
                    self.symbol = json["symbol"].string!
                    ServerAPI.objectWillChange.send()
                    self.shop_id = json["shop_id"].int!
                    ServerAPI.objectWillChange.send()
                    self.theme = settings["theme"].string!
                    self.foreground = settings["foreground"].string!
                    self.public_id = settings["public_id"].string!
                    
                    
                    self.order_minimal_price = settings["min_order_price"].float!
                    self.order_free_delivery_price = settings["min_delivery_price"].float!
                    self.news_block_title = settings["news_title"].string!
                    
                    DispatchQueue.main.async {
                        completionHandlerSettings(true)
                    }
                    
                }
            }
        }
        }else{
            
            
            let json_cached = ServerAPI.cache.cache_read(name: "settings")
            
            if (json_cached != "none"){
                
                let json = JSON.init(parseJSON: json_cached)
                
                let settings = json["settings"]

//                    Setup currency
                ServerAPI.objectWillChange.send()
                self.currency = json["currency"].string!
                self.symbol = json["symbol"].string!
                ServerAPI.objectWillChange.send()
                self.shop_id = json["shop_id"].int!
                ServerAPI.objectWillChange.send()
                self.theme = settings["theme"].string!
                self.foreground = settings["foreground"].string!
                self.public_id = settings["public_id"].string!
                
                
                self.order_minimal_price = settings["min_order_price"].float!
                self.order_free_delivery_price = settings["min_delivery_price"].float!
                self.news_block_title = settings["news_title"].string!
                
                DispatchQueue.main.async {
                    completionHandlerSettings(true)
                }
            }
        }
        
    }
    
    public func log(action: String, about: String = "") {
        
        if (ServerAPI.settings.internet() && ServerAPI.user.username != ""){
            
            AF.request(ServerAPI.settings.url(method: "statistic", dev: true), method: .post, parameters: ["type" : action, "login" : ServerAPI.user.username, "about" : about]).responseJSON { (response) in
                if (response.value != nil) {
                    
                }
            }
            
        }
        
    }
    
    func internet() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(SCNetworkReachabilityCreateWithName(nil, "https://yelm.io")!, &flags)
        
        let reachable = flags.contains(.reachable)
        let connection = flags.contains(.connectionRequired)
        let automated = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let connection_noninteraction = automated && !flags.contains(.interventionRequired)
        
       return reachable && (!connection || connection_noninteraction)
    }
    
}
