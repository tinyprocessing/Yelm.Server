// Server File.swift - contains object class to work with server api.yelm.io

//libs
import DeviceKit
import Alamofire
import SwiftyJSON
import Combine
import SwiftUI
import Foundation

//init class API
public let ServerAPI: Server = Server()

//main class API
open class Server: ObservableObject, Identifiable {
    public var id: Int = 0
    public var system : System = System()
}


