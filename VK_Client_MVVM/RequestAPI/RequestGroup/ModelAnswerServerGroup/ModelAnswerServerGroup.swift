//
//  ModelAnswerServerGroup.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import Foundation

// MARK: - News
struct Groups: Codable {
    var response: GroupsModel
}

// MARK: - Response
struct GroupsModel: Codable {
    var count: Int
    var items: [Group]
}

// MARK: - Item
struct Group: Codable {
    var id: Int
    var name: String
    var isMember: Int
    var photo100: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isMember = "is_member"
        case photo100 = "photo_100"
    }
}

struct JoinOrLeaveGroupModel: Decodable {
    var response: Int
}
