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
                        
                        var images : [String] = []
                        
                        if (object["image"].count > 0){
                            for j in 0...object["image"].count-1{
                                images.append(object["image"][j].string!)
                            }
                        }
                        
                        news.append(news_structure(id: object["id"].int!,
                                                   title: object["title"].string!,
                                                   subtitle: object["subtitle"].string!,
                                                   theme: object["theme"].string!,
                                                   description: object["description"].string!,
                                                   images: images))
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
                    
                    var images : [String] = []
                    
                    if (object["image"].count > 0){
                        for j in 0...object["image"].count-1{
                            images.append(object["image"][j].string!)
                        }
                    }
                    
                    news.append(news_structure(id: object["id"].int!,
                                               title: object["title"].string!,
                                               subtitle: object["subtitle"].string!,
                                               theme: object["theme"].string!,
                                               description: object["description"].string!,
                                               images: images))
                }
                
                
                DispatchQueue.main.async {
                    completionHandlerNews(true, news)
                }
            }
        }
        
    }
}
