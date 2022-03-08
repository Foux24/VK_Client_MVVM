//
//  MyFriendSection.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 05.03.2022.
//

import UIKit

/// Структура для сортировки друзей по ключу
struct FriendSection: Comparable {
    
    /// Ключ
    var key: Character
    
    /// Значение
    var data: [Friends]
    
    /// Сартировка ключей  <
    static func < (lhs: FriendSection, rhs: FriendSection) -> Bool {
        return lhs.key < rhs.key
    }
    
    /// Сартировка ключей  ==
    static func == (lhs: FriendSection, rhs: FriendSection) -> Bool {
        return lhs.key == rhs.key
    }
}
