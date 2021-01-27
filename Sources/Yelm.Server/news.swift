//
//  File.swift
//  
//
//  Created by Michael on 18.01.2021.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON
import SystemConfiguration


public class News: ObservableObject, Identifiable {
    public var id: Int = 0
    
    public func get_news(completionHandlerNews: @escaping (_ success:Bool,_ objects:[news_structure]) -> Void){
        var news: [news_structure] = []
        
        if (ServerAPI.settings.internet()){
            
            AF.request(ServerAPI.settings.url(method: "all-news", dev: true)).responseJSON { (response) in
                if (response.value != nil) {
                    let json = JSON(response.value!)
                    let json_string_cache = json.rawString()
                    
                    if (json.count == 0) {
                        DispatchQueue.main.async {
                            completionHandlerNews(false, [])
                        }
                        return
                    }
                    
                    ServerAPI.cache.cache_items(value: json_string_cache!, name: "news")
                    
                    for i in 0...json.count - 1 {
                        let object = json[i]
                        
                   
                        
                        news.append(news_structure(id: object["id"].int!,
                                                   title: object["title"].string!,
                                                   subtitle: object["subtitle"].string!,
                                                   theme: object["theme"].string!,
                                                   description: object["description"].string!,
                                                   images: object["image"].string!,
                                                   thubnail: object["preview_image"].string!
                                                   ))
                    }
                    
                    
                    DispatchQueue.main.async {
                        completionHandlerNews(true, news)
                    }

                    
                }
            }
            
        }else{
            
            
            let json_cached = ServerAPI.cache.cache_read(name: "news")
            
            if (json_cached != "none"){
                
                let json = JSON.init(parseJSON: json_cached)
                
                
                if (json.count == 0) {
                    DispatchQueue.main.async {
                        completionHandlerNews(false, [])
                    }
                    return
                }
                
                
                for i in 0...json.count - 1 {
                    let object = json[i]
                    
                    
                    news.append(news_structure(id: object["id"].int!,
                                               title: object["title"].string!,
                                               subtitle: object["subtitle"].string!,
                                               theme: object["theme"].string!,
                                               description: object["description"].string!,
                                               images: object["image"].string!,
                                               thubnail: object["preview_image"].string!))
                }
                
                
                DispatchQueue.main.async {
                    completionHandlerNews(true, news)
                }
            }
        }
        
    }
    
    
    
    public func get_news_items(id: Int, completionHandlerItems: @escaping (_ success:Bool,_ objects:[items_structure]) -> Void){
        var items: [items_structure] = []
        
        if (ServerAPI.settings.internet()){
            
            AF.request(ServerAPI.settings.url(method: "news-item", dev: true)+"&id=\(id)").responseJSON { (response) in
                if (response.value != nil) {
                    let json = JSON(response.value!)
                    
                    if (json.count == 0) {
                        DispatchQueue.main.async {
                            completionHandlerItems(false, [])
                        }
                        return
                    }
                    
                    
                    
                    let object = json
                    print(object)
                    
                    
                    for j in 0...object.count - 1  {
                        let item_AF = object[j]
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
                                                    rating: item_AF["rating"].int!))
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        completionHandlerItems(true, items)
                    }

                    
                }
            }
            
        }
        
    }
    
}
