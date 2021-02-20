//
//  File.swift
//  
//
//  Created by Michael on 07.01.2021.
//

import Foundation



public struct categories_local_structure: Identifiable, Hashable  {
    
    public init(id: Int = 0, name: String = "", image: String = "") {
        self.id = id
        self.name = name
        self.image = image
    }

    public var id : Int = 0
    public var name : String = ""
    public var image : String = ""
}


public struct promocode_structure: Identifiable, Hashable  {
    
    public init(id: Int = 0, type: Promocodes = .nonactive, value: Int = 0) {
        self.id = id
        self.type = type
        self.value = value
    }
    
    public var id : Int = 0
    
    public var type : Promocodes = .nonactive
    public var value : Int = 0
}


public struct story_structure: Identifiable, Hashable  {
    
    public init(id: Int = 0, type: String = "", url: String = "") {
        self.id = id
        self.type = type
        self.url = url
    }
    
    public var id : Int = 0
    
    public var type : String = ""
    public var url : String = ""
}

public struct orders_history_count_structure: Identifiable, Hashable {
    
    public init(id: Int, count: Int = 0, item_id: Int = 0) {
        self.id = id
        self.count = count
        self.item_id = item_id
    }
    
    
    
    
    public var id: Int
    public var count: Int = 0
    public var item_id: Int = 0
    
}

public struct orders_history_structure: Identifiable, Hashable {
    
    public init(id: Int, comment: String = "", items: [items_structure] = [], address: String = "", payment: String = "", phone: String = "", items_count: [orders_history_count_structure] = [], end_total: Float = 0.0, created_at: String = "", transaction_status: String = "", latitude: String = "", longitude: String = "") {
        self.id = id
        self.comment = comment
        self.items = items
        self.address = address
        self.payment = payment
        self.phone = phone
        self.items_count = items_count
        self.end_total = end_total
        self.created_at = created_at
        self.transaction_status = transaction_status
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
   
    
    public var id: Int
    
    public var comment: String = ""
    public var items : [items_structure] = []
    public var address : String = ""
    public var payment : String = ""
    public var phone : String = ""
    public var items_count : [orders_history_count_structure] = []
    public var end_total : Float = 0.0
    public var created_at : String = ""
    public var transaction_status : String = ""
    
    public var latitude : String = ""
    public var longitude : String = ""
}

public struct images_structure: Identifiable, Hashable {
    public var id: Int
    /// Name
    public var name: String
}

public struct parameters_structure: Identifiable, Hashable {
    
    public init(id: Int = 0, name: String = "", value: String = "") {
        self.id = id
        self.name = name
        self.value = value
    }
    
    public var id: Int
    /// Parameter Name
    public var name: String
    /// Parameter Value
    public var value: String
}

/// Структура для модификатора
public struct modificator_structure: Identifiable, Hashable {
    /// ID modify
    public var id: Int
    /// Name value
    public var name: String
    /// Price value
    public var value: Float
}

public struct categories_structure: Identifiable, Hashable {
    public var id: Int
    /// Name
    public var title: String = ""
    /// Value
    public var value: String = ""
    /// Image url
    public var image: String = ""
    /// Count in DB
    public var count: Int = 0
    public var ID: String = ""
}


public struct items_main_cateroties: Identifiable, Hashable {
    public var id: Int
    /// Items List
    public var items: [items_structure]
    /// Name of category
    public var name: String = ""
}

public struct items_structure: Identifiable, Hashable {
    
    public init(id: Int = 0, title: String = "", price: String = "", text: String = "", thubnail: String = "", price_float: Float = 0.0, all_images: [String] = [], parameters: [parameters_structure] = [], type: String = "", quanity: String = "", discount: String = "", discount_value: Int = 0, discount_present: String = "", rating: Int = 5, action: [String] = [], amount: Int = 0) {
        self.id = id
        self.title = title
        self.price = price
        self.text = text
        self.thubnail = thubnail
        self.price_float = price_float
        self.all_images = all_images
        self.parameters = parameters
        self.type = type
        self.quanity = quanity
        self.discount = discount
        self.discount_value = discount_value
        self.discount_present = discount_present
        self.rating = rating
        self.action = action
        self.amount = amount

    }
    
    /// ID from YELM system
    public var id: Int
    /// Name of item
    public var title: String = ""
    /// Цена товара
    public var price: String = ""
    /// Text about item
    public var text: String = ""
    /// Image to show init
    public var thubnail: String = ""
    /// Price in Float
    public var price_float: Float = 0.0
    /// list url images
    public var all_images: [String] = []
    /// All params
    public var parameters: [parameters_structure] = []
    /// Type of items loc
    public var type: String = ""
    /// count per type
    public var quanity: String = ""
    /// Discount in percent loded in string
    public var discount: String = ""
    /// Discount percent in Int
    public var discount_value: Int = 0
    /// String to present discount
    public var discount_present: String = ""
    /// Rating from system
    public var rating: Int = 5
    /// Actions for sub actions
    public var action: [String] = []
    /// Count item in shop
    public var amount: Int = 5
    
  

}


/// News Structure
public struct news_structure: Identifiable, Hashable {
    
    
    public init(id: Int, title: String = "", subtitle: String = "", theme: String = "", description: String = "", images: String = "", thubnail: String = "", story: [story_structure] = [], type: String = "") {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.theme = theme
        self.description = description
        self.images = images
        self.thubnail = thubnail
        self.story = story
        self.type = type
    }
    
    

    
    
    /// ID in Yelm System
    public var id: Int
    
    /// News title
    public var title: String = ""
    
    /// News subtitle
    public var subtitle: String = ""
    
    /// News theme
    public var theme: String = ""
    
    /// News body text
    public var description: String = ""
    
    /// News images
    public var images: String = ""
    
    /// Thubnail images
    public var thubnail: String = ""
    
    /// story array
    public var story: [story_structure] = []
    
    /// type
    public var type: String = ""
    
}
