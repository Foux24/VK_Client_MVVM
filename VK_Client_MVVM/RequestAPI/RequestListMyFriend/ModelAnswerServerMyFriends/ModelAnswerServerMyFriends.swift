//
//  ModelAnswerServerMyFriends.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import Foundation

// MARK: - News
struct FriendsList: Codable {
    var response: FriendModel
}

// MARK: - Response
struct FriendModel: Codable {
    var count: Int
    var items: [Friends]
}

// MARK: - Item
struct Friends: Codable {
    var firstName: String
    var id: Int
    var lastName: String
    var photo200_Orig: String
    var deactivated: String?
    var status: String?
    var domain: String?
    var lastSeen: LastSeen?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photo200_Orig = "photo_200_orig"
        case deactivated
        case status = "status"
        case domain
        case lastSeen = "last_seen"
    }
}

struct LastSeen: Codable {
    var time: Double
    
    enum CodingKeys: String, CodingKey {
        case time
    }
}
