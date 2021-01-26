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


//TODO - Write Cache Policy

public class Items: ObservableObject, Identifiable {
    public var id: Int = 0
    
    
    public func get_items_all(completionHandlerItemsAll: @escaping (_ success:Bool,_ objects:[items_structure]) -> Void){
        var items: [items_structure] = []
        
        
        if (ServerAPI.settings.internet()){
            
            AF.request(ServerAPI.settings.url(method: "search", dev: true)+"&shop_id=\(ServerAPI.settings.shop_id)").responseJSON { (response) in
                if (response.value != nil) {
                    let json = JSON(response.value!)
                    let json_string_cache = json.rawString()

                   
                    
                    if (json.count == 0) {
                        DispatchQueue.main.async {
                            completionHandlerItemsAll(false, [])
                        }
                        return
                    }
                    
                   
                    ServerAPI.cache.cache_items(value: json_string_cache!, name: "items_all")

                    
                    for i in 0...json.count - 1 {
                        let item_AF = json[i]
                        
                        let price_AF = Float(item_AF["discount"].int!) / 100
                        let discount_AF = item_AF["price"].float! * price_AF
                        let discount_final = item_AF["price"].float! - discount_AF
                        let final = discount_final
                        
                        let parameter_AF = item_AF["specification"]
                        var parameters : [parameters_structure] = []
                        
                        if (parameter_AF.count > 0){
                            for k in 0...parameter_AF.count - 1 {
                                let parameter_single = parameter_AF[k]
                                let name = parameter_single["name"].string!
                                let value = parameter_single["value"].string!
                                parameters.append(parameters_structure(id: item_AF["id"].int!, name: name, value: value))
                            }
                        }
                        
                        items.append(items_structure(id: item_AF["id"].int!,
                                                    title: item_AF["name"].string!,
                                                    price: String(format:"%.2f", item_AF["price"].float!),
                                                    text: item_AF["description"].string!,
                                                    thubnail: item_AF["images"][0].string!,
                                                    price_float: item_AF["price"].float!,
                                                    all_images: [],
                                                    parameters: parameters,
                                                    type: item_AF["type"].string!,
                                                    quanity: "\(item_AF["unit_type"].int!)",
                                                    discount: String(format:"%.2f", final),
                                                    discount_value: item_AF["discount"].int!,
                                                    discount_present: "-\(item_AF["discount"].int!)%",
                                                    ItemRating: 5))
                        
                    }
                    
                    DispatchQueue.main.async {
                        completionHandlerItemsAll(true, items)
                    }
                    
                }
            }
            
        }else{
            let json_cached = ServerAPI.cache.cache_read(name: "items_all")
            
            if (json_cached != "none"){
                
                let json = JSON.init(parseJSON: json_cached)
                
                if (json.count == 0) {
                    DispatchQueue.main.async {
                        completionHandlerItemsAll(false, [])
                    }
                    return
                }

                
                for i in 0...json.count - 1 {
                    let item_AF = json[i]
                    
                    let price_AF = Float(item_AF["discount"].int!) / 100
                    let discount_AF = item_AF["price"].float! * price_AF
                    let discount_final = item_AF["price"].float! - discount_AF
                    let final = discount_final
                    
                 
                    
                    let parameter_AF = item_AF["specification"]
                    var parameters : [parameters_structure] = []
                    
                    if (parameter_AF.count > 0){
                        for k in 0...parameter_AF.count - 1 {
                            let parameter_single = parameter_AF[k]
                            let name = parameter_single["name"].string!
                            let value = parameter_single["value"].string!
                            parameters.append(parameters_structure(id: item_AF["id"].int!, name: name, value: value))
                        }
                    }
                    
                    items.append(items_structure(id: item_AF["id"].int!,
                                                title: item_AF["name"].string!,
                                                price: String(format:"%.2f", item_AF["price"].float!),
                                                text: item_AF["description"].string!,
                                                thubnail: item_AF["images"][0].string!,
                                                price_float: item_AF["price"].float!,
                                                all_images: [],
                                                parameters: parameters,
                                                type: item_AF["type"].string!,
                                                quanity: "\(item_AF["unit_type"].int!)",
                                                discount: String(format:"%.2f", final),
                                                discount_value: item_AF["discount"].int!,
                                                discount_present: "-\(item_AF["discount"].int!)%",
                                                ItemRating: 5))
                    
                }
                
                DispatchQueue.main.async {
                    completionHandlerItemsAll(true, items)
                }
                
            }else{
                
                DispatchQueue.main.async {
                    completionHandlerItemsAll(false, [])
                }
                
            }
        }
        
       
    }
    
    public func get_items(completionHandlerItems: @escaping (_ success:Bool,_ objects:[items_main_cateroties]) -> Void){
        
        var items: [items_main_cateroties] = []
//        check internet connection
        
        if (ServerAPI.settings.internet()){
            
            AF.request(ServerAPI.settings.url(method: "items", dev: true)).responseJSON { (response) in
                if (response.value != nil) {
                    let json = JSON(response.value!)
                    let json_string_cache = json.rawString()
                    
                    if (json.count == 0) {
                        DispatchQueue.main.async {
                            completionHandlerItems(false, [])
                        }
                        return
                    }
                    
                    ServerAPI.cache.cache_items(value: json_string_cache!, name: "items_main")
                    
                    for i in 0...json.count - 1 {
                        let object = json[i]
                        let name = object["name"].string!
                        var list : [items_structure] = []
                        
                        for j in 0...object["items"].count - 1  {
                            let item_AF = object["items"][j]
    //                        math discount
                            let price_AF = Float(item_AF["discount"].int!) / 100
                            let discount_AF = item_AF["price"].float! * price_AF
                            let discount_final = item_AF["price"].float! - discount_AF
                            let final = discount_final
                            
                            let parameter_AF = item_AF["specification"]
                            var parameters : [parameters_structure] = []
                            
                            if (parameter_AF.count > 0){
                                for k in 0...parameter_AF.count - 1 {
                                    let parameter_single = parameter_AF[k]
                                    let name = parameter_single["name"].string!
                                    let value = parameter_single["value"].string!
                                    parameters.append(parameters_structure(id: item_AF["id"].int!, name: name, value: value))
                                }
                            }
                           
                      
                            
                            
    //                        add all items in list
                            list.append(items_structure(id: item_AF["id"].int!,
                                                        title: item_AF["name"].string!,
                                                        price: String(format:"%.2f", item_AF["price"].float!),
                                                        text: item_AF["description"].string!,
                                                        thubnail: item_AF["images"][0].string!,
                                                        price_float: item_AF["price"].float!,
                                                        all_images: [],
                                                        parameters: parameters,
                                                        type: item_AF["type"].string!,
                                                        quanity: "\(item_AF["unit_type"].int!)",
                                                        discount: String(format:"%.2f", final),
                                                        discount_value: item_AF["discount"].int!,
                                                        discount_present: "-\(item_AF["discount"].int!)%",
                                                        ItemRating: item_AF["rating"].int!))
                            
                        }
    //                    add object to main view with attachment
                        ServerAPI.items.objectWillChange.send()
                        items.append(items_main_cateroties(id: i, items: list, name: name))
                    }
    //                End add to items list and foreach
                    if (ServerAPI.settings.debug){
                        print(items)
                    }
                    
                    DispatchQueue.main.async {
                        completionHandlerItems(true, items)
                    }
                }
            }
            
        }else{
            let json_cached = ServerAPI.cache.cache_read(name: "items_main")
            
            if (json_cached != "none"){
                
                let json = JSON.init(parseJSON: json_cached)
                
                
                if (json.count == 0) {
                    DispatchQueue.main.async {
                        completionHandlerItems(false, [])
                    }
                    return
                }
                
                for i in 0...json.count - 1 {
                    let object = json[i]
                    let name = object["name"].string!
                    var list : [items_structure] = []
                    
                    for j in 0...object["items"].count - 1  {
                        let item_AF = object["items"][j]
//                        math discount
                        let price_AF = Float(item_AF["discount"].int!) / 100
                        let discount_AF = item_AF["price"].float! * price_AF
                        let discount_final = item_AF["price"].float! - discount_AF
                        let final = discount_final
                        
                        let parameter_AF = item_AF["specification"]
                        var parameters : [parameters_structure] = []
                        
                        if (parameter_AF.count > 0){
                            for k in 0...parameter_AF.count - 1 {
                                let parameter_single = parameter_AF[k]
                                let name = parameter_single["name"].string!
                                let value = parameter_single["value"].string!
                                parameters.append(parameters_structure(id: item_AF["id"].int!, name: name, value: value))
                            }
                        }
                       
                        
//                        add all items in list
                        list.append(items_structure(id: item_AF["id"].int!,
                                                    title: item_AF["name"].string!,
                                                    price: String(format:"%.2f", item_AF["price"].float!),
                                                    text: item_AF["description"].string!,
                                                    thubnail: item_AF["images"][0].string!,
                                                    price_float: item_AF["price"].float!,
                                                    all_images: [],
                                                    parameters: parameters,
                                                    type: item_AF["type"].string!,
                                                    quanity: "\(item_AF["unit_type"].int!)",
                                                    discount: String(format:"%.2f", final),
                                                    discount_value: item_AF["discount"].int!,
                                                    discount_present: "-\(item_AF["discount"].int!)%",
                                                    ItemRating: item_AF["rating"].int!))
                        
                    }
//                    add object to main view with attachment
                    ServerAPI.items.objectWillChange.send()
                    items.append(items_main_cateroties(id: i, items: list, name: name))
                }
                
                DispatchQueue.main.async {
                    completionHandlerItems(true, items)
                }
                
                
            }else{
                
                DispatchQueue.main.async {
                    completionHandlerItems(false, [])
                }
                
            }
        }

    }
    
    public func subcategories(id: Int, completionHandlerSubcategories: @escaping (_ success:Bool,_ objects:[items_main_cateroties]) -> Void){
        
    }
}
