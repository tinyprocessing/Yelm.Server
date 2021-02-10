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
