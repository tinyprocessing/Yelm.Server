//
//  File.swift
//  
//
//  Created by Michael on 25.01.2021.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON
import SystemConfiguration


public class Basket: ObservableObject, Identifiable {
    public var id: Int = 0
    
    /// Get information from server about order
    /// - Parameters:
    ///   - items: list of items Id's
    ///   - completionHandlerBasket: Handler
    public func get_basket(items: JSON, completionHandlerBasket: @escaping (_ success:Bool) -> Void){
        
        print(items.rawString()!)
        
        AF.request(ServerAPI.settings.url(method: "basket", dev: true), method: .post, parameters: ["items": items.rawString()!, "shop_id" : ServerAPI.settings.shop_id]).responseJSON { (response) in
      
            if (response.value != nil && response.response?.statusCode == 200) {
                
                let json = JSON(response.value!)
                
                
                if (json.count == 0) {
                    DispatchQueue.main.async {
                        completionHandlerBasket(false)
                    }
                    return
                }
                
                ServerAPI.settings.deliverly_time = json["delivery"]["time"].string!
                ServerAPI.settings.deliverly_price = json["delivery"]["price"].float!
                
                DispatchQueue.main.async {
                    completionHandlerBasket(true)
                }
                
                
            }
        }
        
    }
    
}
