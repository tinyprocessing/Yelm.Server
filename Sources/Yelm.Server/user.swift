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
    
    
    public func notifications(user: String, token: String){
        print("your token = " + token)
        AF.request(ServerAPI.settings.url(method: "user", dev: true), method: .put, parameters: ["login" : user, "push": token]).responseJSON { (response) in
            
            if (response.value != nil) {
                if (ServerAPI.settings.debug){
                    print(response.value)
                }
            }
        }
        
    }
    
    public func registration(completionHandlerUser: @escaping (_ success:Bool, _ user: String) -> Void){
        
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
