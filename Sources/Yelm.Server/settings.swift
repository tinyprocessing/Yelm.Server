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

let version : String = "3.0"


public class Settings: ObservableObject, Identifiable {
    public var id: Int = 0
    var domain : String = "https://rest.yelm.io/api/"
    var position : String = ""
    var platform : String = ""
    public var debug : Bool = true
    
//    Settings for application from server
    public var deliverly : Bool = false
    public var takeoff : Bool = false
    public var payments : Bool = false
    public var price : String = "USD"
    
    /// Get url to connect rest api
    /// - Parameter method: Method Name - example m-application
    /// - Returns: Ready string
    func url(method: String) -> String {
        var url : String = ""
        if (Locale.current.regionCode != nil && Locale.current.languageCode != nil){
            
            url = self.domain
            url += method
            url += "?Version=\(version)&RegionCode=\(Locale.current.regionCode!)&LanguageCode=\(Locale.current.languageCode!)&Platform=\(self.platform)"
            if (self.position == ""){
                url += "&LAT=0&LON=0"
            }else{
                url += position
            }
          
            
        }else{

            url = self.domain
            url += method
            url += "?Version=\(version)&RegionCode=US&LanguageCode=en&Platform=\(self.platform)"
            if (self.position == ""){
                url += "&LAT=0&LON=0"
            }else{
                url += position
            }
            
        }
        
        if (self.debug){
            print(url)
        }
        return url
    }
    
    
    
    /// Get settings from server for platform
    public func get_settings(){
        AF.request(self.url(method: "m-application")).responseJSON { (response) in
            if (response.value != nil) {
                let json = JSON(response.value!)[0]
                if (json.count > 0){
                    if (self.debug){
                        print(json)
                    }
//                    Payments disallow
                    if (json["AllowPayments"].string! == "false"){
                        self.payments = false
                    }
//                    Payments allow
                    if (json["AllowPayments"].string! == "true"){
                        self.payments = true
                    }
//                    Deliverly disallow
                    if (json["allowDeliverly"].int! == 0){
                        self.deliverly = false
                    }
//                    Deliverly allow
                    if (json["allowDeliverly"].int! == 1){
                        self.deliverly = true
                    }
                    
//                    Setup currency
                    self.price = json["CNT"].string!
                    
                    
                }
            }
        }
    }
    
}
