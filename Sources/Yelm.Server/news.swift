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
                        
                        let type : String = object["type"].string!
                        var stories : [story_structure] = []
                        if (object["type"].string! == "story"){
                            for j in 0...object["story"]["urls"].count - 1 {
                                stories.append(story_structure(id: j,
                                                               type: object["story"]["urls"][j]["type"].string!,
                                                               url: object["story"]["urls"][j]["url"].string!))
                            }
                        }
                   
                        
                        news.append(news_structure(id: object["id"].int!,
                                                   title: object["title"].string!,
                                                   subtitle: "",
                                                   theme: "",
                                                   description: object["description"].string!,
                                                   images: object["image"].string!,
                                                   thubnail: object["preview_image"].string!,
                                                   story: stories,
                                                   type: type
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
                    
                    let type : String = object["type"].string!
                    var stories : [story_structure] = []
                    if (object["type"].string! == "story"){
                        for j in 0...object["story"]["urls"].count - 1 {
                            stories.append(story_structure(id: j,
                                                           type: object["story"]["urls"][j]["type"].string!,
                                                           url: object["story"]["urls"][j]["url"].string!))
                        }
                    }
               
                    
                    news.append(news_structure(id: object["id"].int!,
                                               title: object["title"].string!,
                                               subtitle: "",
                                               theme: "",
                                               description: object["description"].string!,
                                               images: object["image"].string!,
                                               thubnail: object["preview_image"].string!,
                                               story: stories,
                                               type: type
                                               ))
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
                       
                  
                        var images : [String] = []
                        for k in 0...item_AF["images"].count-1{
                            images.append(item_AF["images"][k].string!)
                        }
                        
//                        add all items in list
                        items.append(items_structure(id: item_AF["id"].int!,
                                                    title: item_AF["name"].string!,
                                                    price: String(format:"%.2f", item_AF["price"].float!),
                                                    text: item_AF["description"].string!,
                                                    thubnail: item_AF["preview_image"].string!,
                                                    price_float: item_AF["price"].float!,
                                                    all_images: images,
                                                    parameters: parameters,
                                                    type: item_AF["type"].string!,
                                                    quanity: "\(item_AF["unit_type"].int!)",
                                                    discount: String(format:"%.2f", final),
                                                    discount_value: item_AF["discount"].int!,
                                                    discount_present: "-\(item_AF["discount"].int!)%",
                                                    rating: item_AF["rating"].int!,
                                                    amount: item_AF["quantity"].int!))
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        completionHandlerItems(true, items)
                    }

                    
                }
            }
            
        }
        
    }
    
}
