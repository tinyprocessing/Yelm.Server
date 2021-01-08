//
//  File.swift
//  
//
//  Created by Michael on 07.01.2021.
//

import Foundation
import DeviceKit
import Alamofire
import SwiftyJSON
import Combine
import SwiftUI


public class User: ObservableObject, Identifiable {
    public var id: Int = 0
    public var username: String = ""
    
    
    public func registration(completionHandlerUser: @escaping (_ success:Bool, _ user: String) -> Void){
        
        let data_system = ServerAPI.system.data_string()
        print(data_system)
        
        AF.request(ServerAPI.settings.url(method: "user", dev: true), method: .post, parameters: ["user_info" : ServerAPI.system.data_json()]).responseJSON { (response) in
            
            if (response.value != nil) {
                
                let json = JSON(response.value!)
                if (ServerAPI.settings.debug){
                    print(json)
                }
                DispatchQueue.main.async {
                    completionHandlerUser(true, json["login"].string!)
                }
                
            }
        }
        
      
    }
    
    
}
