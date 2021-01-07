//
//  File.swift
//  
//
//  Created by Michael on 07.01.2021.
//

import Foundation


public struct images_structure: Identifiable, Hashable {
    public var id: Int
    /// Name
    public var name: String
}

public struct parameters_structure: Identifiable, Hashable {
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

public struct cateroties_structure: Identifiable, Hashable {
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
    public var ItemRating: Int = 5

}
