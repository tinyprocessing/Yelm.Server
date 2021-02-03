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
    
}

public class OrdersDetail: ObservableObject, Identifiable {
    
    public init(id: Int = 0,
                phone: String = "",
                comment: String = "",
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
                parameters: [String : Any] = [:]) {
        
        self.id = id
        self.phone = phone
        self.comment = comment
        self.address = address
        self.flat = flat
        self.entrance = entrance
        self.floor = floor
        self.total = total
        self.discount = discount
        self.delivery = delivery
        self.payment = payment
        self.transaction_id = transaction_id
        self.items = items
        self.parameters = parameters
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
    public var delivery: Float = 0.0
    public var payment: String = ""
    public var transaction_id: String = ""
    public var items : JSON = JSON()
    
    public var parameters : [String : Any] = [:]
    
    func build() -> [String : Any] {
        self.parameters = [:]
        
        self.parameters = [
            "phone" : self.phone,
            "comment" : self.comment,
            "address" : self.address,
            "flat" : self.flat,
            "entrance" : self.entrance,
            "floor" : self.floor,
            "total" : self.total,
            "discount" : self.discount,
            "delivery" : self.delivery,
            "payment" : self.payment,
            "transaction_id" : self.transaction_id,
            "items" : self.items.rawString() ?? ""
        ]
        
        return self.parameters
    }
}
