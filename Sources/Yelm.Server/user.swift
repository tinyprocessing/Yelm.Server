//
//  File.swift
//  
//
//  Created by Michael on 07.01.2021.
//

import Foundation

import Alamofire
import SwiftyJSON
import Combine
import SwiftUI


public class User: ObservableObject, Identifiable {
    public var id: Int = 0
    public var username: String = ""
    public var phone: String = ""
    

    
    public func notifications(user: String, token: String){
        
        AF.request(ServerAPI.settings.url(method: "user", dev: true), method: .put, parameters: ["login" : user, "push": token]).responseJSON { (response) in
            
            if (response.value != nil) {
                
            }
        }
        
    }
    
    public func registration(completionHandlerUser: @escaping (_ success:Bool, _ user: String) -> Void){
        
        
        
        
        #if os(iOS)
        AF.request(ServerAPI.settings.url(method: "user", dev: true), method: .post, parameters: ["user_info" : ServerAPI.system.data_string()]).responseJSON { (response) in
            
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
        #endif
    }
    
    
    public func account_login(phone: String, completionHandlerUser: @escaping (_ success:Bool,
                                                                               _ user: String,
                                                                               _ json: JSON) -> Void){
        
        self.phone = phone
        
        print(ServerAPI.settings.url(method: "auth", dev: false))
        
        AF.request(ServerAPI.settings.url(method: "auth", dev: false), method: .post, parameters: ["phone" : self.phone, "login": ServerAPI.user.username]).responseJSON { (response) in
            
            if (response.value != nil && response.response?.statusCode == 200) {
                
                
                let json = JSON(response.value!)
                
                print(json)
                
                
                DispatchQueue.main.async {
                    completionHandlerUser(true, json["hash"].string!, json)
                }
                
            }else{
                DispatchQueue.main.async {
                    completionHandlerUser(false, "", JSON())
                }
            }
        }
        
        
    }
    
    
    
    public func account_get_information(completionHandlerUser: @escaping (_ success:Bool,
                                                                          _ json: JSON) -> Void){
        
        AF.request(ServerAPI.settings.url(method: "user", dev: false), method: .get, parameters: ["login": ServerAPI.user.username]).responseJSON { (response) in
            
            if (response.value != nil && response.response?.statusCode == 200) {
                
                
                let json = JSON(response.value!)
                
                print(json)
                
                DispatchQueue.main.async {
                    completionHandlerUser(true, json)
                }
                
            }else{
                DispatchQueue.main.async {
                    completionHandlerUser(false, JSON())
                }
            }
        }
        
    }
    
    
    public func account_update(name: String, notification: Bool, completionHandlerUser: @escaping (_ success:Bool) -> Void){
        
        
        
        
        
        AF.request(ServerAPI.settings.url(method: "user-data", dev: false), method: .put, parameters: ["name" : name,
                                                                                                   "login": ServerAPI.user.username,
                                                                                                   "notification" : notification]).responseJSON { (response) in
            
            if (response.value != nil && response.response?.statusCode == 200) {
                
                
                
                DispatchQueue.main.async {
                    completionHandlerUser(true)
                }
                
            }else{
                DispatchQueue.main.async {
                    completionHandlerUser(false)
                }
            }
        }
        
        
    }
    
}
