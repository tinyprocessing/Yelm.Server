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
    
    
    
    public func set(promo: String = "", completionHandlerPromocode: @escaping (_ success:Bool, _ promocode:promocode_structure) -> Void){
       
        
        var active : promocode_structure = promocode_structure(id: 0, type: .nonactive, value: 0)
        
        if (promo == "full"){
            
            active = promocode_structure(id: 0, type: .full, value: 7000)
        }
        
        if (promo == "delivery"){
            active = promocode_structure(id: 0, type: .delivery, value: 100)
        }
        
        if (promo == "percent"){
            active = promocode_structure(id: 0, type: .percent, value: 100)
        }
        
        DispatchQueue.main.async {
            completionHandlerPromocode(true, active)
        }
        
        
    }
 
    public func get(promo: String = "", user: String = ServerAPI.user.username, completionHandlerPromocode: @escaping (_ success:Bool) -> Void) {
        
        AF.request(ServerAPI.settings.url(method: "promocode", dev: true), method: .post, parameters: ["login": user, "promocode" : promo]).responseJSON { (response) in
      
            if (response.value != nil && response.response?.statusCode == 200) {
                
                let json = JSON(response.value!)
                print(json)
                
                
                DispatchQueue.main.async {
                    completionHandlerPromocode(true)
                }
                
                
            }
        }
        
    }
    
    
}
