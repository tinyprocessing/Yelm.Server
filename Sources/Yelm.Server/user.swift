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
    
    
    public func registration(completionHandlerUser: @escaping (_ success:Bool) -> Void){
        
        let data_system = ServerAPI.system.data_string()
        print(data_system)
        
        DispatchQueue.main.async {
            completionHandlerUser(true)
        }
    }
    
    
}
