//
//  File.swift
//  
//
//  Created by Michael on 09.02.2021.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON
import SystemConfiguration


public class Promocode: ObservableObject, Identifiable {
    public var id: Int = 0
    
    
    
 
    public func get(promo: String = "", user: String = ServerAPI.user.username, completionHandlerPromocode: @escaping (_ success:Bool, _ message : String, _ promocode:promocode_structure) -> Void) {
        
        
        AF.request(ServerAPI.settings.url(method: "promocode", dev: true), method: .post, parameters: ["login": user, "promocode" : promo]).responseJSON { (response) in
      
            if (response.value != nil && response.response?.statusCode == 200) {
                
                
                var active : promocode_structure = promocode_structure(id: 0, type: .nonactive, value: 0)
                
                let json = JSON(response.value!)
                var message : String = ""
                
                if (json["status"].int! == 200){
                    message = json["message"].string!
                    let amount : Int = json["promocode"]["amount"].int!
                    
                    if (json["promocode"]["type"].string! == "full"){
                        
                        active = promocode_structure(id: 0, type: .full, value: amount)
                    }
                    
                    if (json["promocode"]["type"].string! == "delivery"){
                        active = promocode_structure(id: 0, type: .delivery, value: amount)
                    }
                    
                    if (json["promocode"]["type"].string! == "percent"){
                        active = promocode_structure(id: 0, type: .percent, value: amount)
                    }
                    
                }
                
                if (json["status"].int! == 204){
                    message = json["message"].string!
                }
                
                if (json["status"].int! == 225){
                    message = json["message"].string!
                }
                
                if (json["status"].int! == 404){
                    message = json["message"].string!
                }
                
                DispatchQueue.main.async {
                    completionHandlerPromocode(true, message, active)
                }
                
                
            }else{
                
                
                DispatchQueue.main.async {
                    completionHandlerPromocode(false, "server error", promocode_structure(id: 0, type: .nonactive, value: 0))
                }
                
            }
        }
        
    }
    
    
}
