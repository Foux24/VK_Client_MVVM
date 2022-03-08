//
//  Session.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

class Session {
    
    static let instance = Session()
    
    private init(){}
    
    var token: String?
    var userId: Int?
    
}
