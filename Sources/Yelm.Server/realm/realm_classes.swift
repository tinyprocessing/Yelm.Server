//
//  File.swift
//  
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import RealmSwift


class CachedStrings: Object {
    @objc dynamic var id = 0
    @objc dynamic var value : String = ""
    @objc dynamic var name : String = ""
}
