//
//  ModelAnswerServerNews.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import Foundation

// MARK: - News
struct News: Decodable {
    var response: Response
}

// MARK: - Response
struct Response: Decodable {
    var items: [MyNews]
    var profiles: [ProfileNews]
    var groups: [GroupNews]
    var nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

// MARK: - ResponseItem
struct MyNews: Decodable {
    var sourceID: Int
    var date: Double
    var text: String?
    var attachments: [ItemAttachment]?
    var likes: PurpleLikes?
    var reposts: RepostsNews?
    var views: Views?
    var postID: Int

    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case text
        case attachments
        case likes
        case reposts
        case views
        case postID = "post_id"
    }
}

// MARK: - ItemAttachment
struct ItemAttachment: Decodable {
    var type: String?
    var photo: PurplePhoto?
    var video: VideoElement?
}

// MARK: - VideoElement
struct VideoElement: Decodable {
    var photo800: String

    enum CodingKeys: String, CodingKey {
        case photo800 = "photo_800"
    }
}

// MARK: - PurpleLikes
struct PurpleLikes: Codable {
    var canLike: Int
    var count: Int
    var userLikes: Int
    var canPublish: Int

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case count
        case userLikes = "user_likes"
        case canPublish = "can_publish"
    }
}

// MARK: - Reposts
struct RepostsNews: Codable {
    var count: Int
    var userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Views
struct Views: Codable {
    var count: Int
}

// MARK: - Group
struct GroupNews: Decodable {
    var id: Int
    var name: String
    var photo100: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case photo100 = "photo_100"
    }
}

// MARK: - Profile
struct ProfileNews: Decodable {
    var firstName: String
    var id: Int
    var lastName: String
    var photo100: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
}

// MARK: - PurplePhoto
struct PurplePhoto: Decodable {
    var date: Double
    var sizes: [SizeNews]


    enum CodingKeys: String, CodingKey {
        case date
        case sizes
    }
}
// MARK: - Size
struct SizeNews: Decodable {
    let height: Int
    var url: String
    let width: Int
}

// MARK: - News
struct LikePost: Decodable {
    var response: AddOrDeletLikePost
}

// MARK: - Response
struct AddOrDeletLikePost: Decodable {
    var likes: Int
    
    enum CodingKeys: String, CodingKey {
        case likes
    }
}
