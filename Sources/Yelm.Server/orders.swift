//
//  File.swift
//  
//
//  Created by Michael on 02.02.2021.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON
import SystemConfiguration


public class Orders: ObservableObject, Identifiable {
    public var id: Int = 0
    
    
    /// History
    /// - Parameters:
    ///   - id: id of order
    ///   - completionHandlerHistory: orders_history_structure
    public func get_order_history(id: String, completionHandlerHistory: @escaping (_ success:Bool, _ object : orders_history_structure) -> Void){
        
        var order : orders_history_structure = orders_history_structure(id: 0)
        
        AF.request(ServerAPI.settings.url(method: "order", dev: true), method: .get, parameters: ["id" : id]).responseJSON { (response) in
            
            if (response.value != nil && response.response?.statusCode == 200) {
                
                let json = JSON(response.value!)
                
                
                order.id = Int(id)!
                order.comment = json["comment"].string!
                order.payment = json["payment"].string!
                order.address = json["address"].string!
                order.phone = json["phone"].string!
                order.end_total = json["end_total"].float!
                order.created_at = String(json["created_at"].string!.split(separator: "T")[0])
                order.transaction_status = json["transaction_status"].string!
                
                order.longitude = json["longitude"].string!
                order.latitude = json["latitude"].string!
                
                order.ofd = json["ofd_receipt"].string!
                
                var list : [items_structure] = []
                
                for j in 0...json["items_info"].count - 1  {
                    let item_AF = json["items_info"][j]
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
                    list.append(items_structure(id: item_AF["id"].int!,
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
              
                order.items = list
                
                var list_count : [orders_history_count_structure] = []
                for s in 0...json["items"].count - 1  {
                    list_count.append(orders_history_count_structure(id: s, count: json["items"][s]["count"].int!, item_id: json["items"][s]["id"].int!))
                }
                
                order.items_count = list_count
                
                DispatchQueue.main.async {
                    completionHandlerHistory(true, order)
                }
            }
            
        }
        
    }
    
    
    /// Get information from server about order
    /// - Parameters:
    ///   - items: list of items Id's
    ///   - completionHandlerBasket: Handler
    public func set_order(order: OrdersDetail, completionHandlerOrder: @escaping (_ success:Bool) -> Void){
        
        
        
        
        AF.request(ServerAPI.settings.url(method: "order", dev: true), method: .post, parameters: order.build()).responseJSON { (response) in
        
            
            if (response.value != nil && response.response?.statusCode == 200) {
                
                DispatchQueue.main.async {
                    completionHandlerOrder(true)
                }
                
                
            }
        }
        
    }
    
    public func set_temporary_orders(item_id : Int, action : String, count : Int,  completionHandlerOrderTemporary: @escaping (_ success:Bool) -> Void){
        
        
        AF.request(ServerAPI.settings.url(method: "action", dev: true), method: .post, parameters: ["item_id" : item_id, "action": action, "count": count]).responseJSON { (response) in
          
            if (response.value != nil && response.response?.statusCode == 200) {
                
                DispatchQueue.main.async {
                    completionHandlerOrderTemporary(true)
                }
                
            }
        }
    }
    
    
}

public class OrdersDetail: ObservableObject, Identifiable {
    
    public init(id: Int = 0,
                phone: String = "",
                comment: String = "comment",
                address: String = "",
                flat: String = "",
                entrance: String = "",
                floor: String = "",
                total: Float = 0.0,
                discount: Float = 0.0,
                delivery: Float = 0.0,
                payment: String = "",
                transaction_id: String = "",
                items: JSON = JSON(),
                currency : String = "",
                start_price : Float = 0.0,
                parameters: [String : Any] = [:],
                shop_id : Int = 0,
                discount_type : String = "") {
        
        self.id = id
        self.phone = phone
        self.comment = comment
        self.address = address
        self.flat = flat
        self.entrance = entrance
        self.floor = floor
        self.total = total
        self.discount = discount
        self.delivery_price = delivery
        self.payment = payment
        self.transaction_id = transaction_id
        self.items = items
        self.parameters = parameters
        self.currency_value = currency
        self.start_price = start_price
        self.shop_id = shop_id
        self.discount_type = discount_type
    }
    
    public var id: Int = 0
    public var phone: String = ""
    public var comment: String = ""
    public var address: String = ""
    public var flat: String = ""
    public var entrance: String = ""
    public var floor: String = ""
    public var total: Float = 0.0
    public var discount: Float = 0.0
    public var delivery_price: Float = 0.0
    public var payment: String = ""
    public var currency_value: String = ""
    public var transaction_id: String = ""
    public var start_price: Float = 0.0
    public var items : JSON = JSON()
    public var parameters : [String : Any] = [:]
    public var shop_id: Int = ServerAPI.settings.shop_id
    public var discount_type: String = ""
    
    func build() -> [String : Any] {
        self.parameters = [:]
        
        self.parameters = [
            "phone" : self.phone,
            "comment" : "comment",
            "address" : self.address,
            "flat" : self.flat,
            "entrance" : self.entrance,
            "floor" : self.floor,
            "end_total" : self.total,
            "start_total" : self.start_price,
            "discount" : self.discount,
            "delivery" : "delivery",
            "payment" : self.payment,
            "transaction_id" : self.transaction_id,
            "items" : self.items,
            "login" : ServerAPI.user.username,
            "delivery_price" : self.delivery_price,
            "currency" : self.currency_value,
            "shop_id" : self.shop_id,
            "discount_type" : self.discount_type
        ]
        
        return self.parameters
    }
}
