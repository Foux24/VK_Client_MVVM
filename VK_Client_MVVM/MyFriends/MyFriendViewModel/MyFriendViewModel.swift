//
//  MyFriendViewModel.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

/// Протокол реализации ViewModel
protocol MyFriendViewModelProtocol: AnyObject {
    var loadFriends: RequestServerMyFriend { get }
    func sortFriends(_ array: [Friends]) -> [Character: [Friends]]
    func formFriendSection(_ array: [Character: [Friends]]) -> [FriendSection]
    func formFriendArray(from array: [Friends]) -> [FriendSection]
    func loadLetter() -> Void
    func getListMyfriend(complition: @escaping ([FriendSection]) -> Void)
}

/// Протокол с выходными данными от ViewModel
protocol MyFriendViewModelOutput: AnyObject {
    var defaultImage: UIImage { get }
    var arrayLettersOfNames: [String] { get set }
    var arrayFriend: [FriendSection] { get set }
    var arrayFilteredFriendData: [FriendSection] { get set }
    var fileManager: HashPhotoService? { get set }
    func getSortedFriend(completion: @escaping () -> Void)
    func serachBarFiltered(searchText: String) -> Void
}

protocol MyFriendViewModelInput: AnyObject {
    func serachBarFiltered(searchText: String) -> Void
}

final class MyFriendViewModel: MyFriendViewModelOutput {
    
    /// Ссылка на class по загрузке списка друзей
    let loadFriends = RequestServerMyFriend()
    
    /// Для кеша изоборажений
    var fileManager: HashPhotoService?
    
    /// Default Image
    var defaultImage: UIImage = UIImage(systemName: "photo")!
    
    /// Свойство для фильтра друзей
    var arrayFriend = [FriendSection]()
    
    /// создадим переменную в которую запишем массив фильтрованных секций с друзьями
    var arrayFilteredFriendData = [FriendSection]()
    
    /// создадим переменную которая будет хранить в себе массив из стринговых значений
    var arrayLettersOfNames = [String]()
    
    /// Метод запускающий полный цикл фильтра друзей наполнение данными ViewModel
    func getSortedFriend(completion: @escaping () -> Void) {
        getListMyfriend { [weak self] friends in
            guard let self = self else { return }
            self.arrayFriend = friends
            self.arrayFilteredFriendData = friends
            self.loadLetter()
            completion()
        }
    }
}

extension MyFriendViewModel: MyFriendViewModelProtocol {
    
    /// Сортировка друзей в словарь
    func sortFriends(_ array: [Friends]) -> [Character: [Friends]] {
        var newArray: [Character: [Friends]] = [:]
        for user in array {
            guard let firstChar = user.firstName.first else { continue }
            guard var array = newArray[firstChar] else { let newValue = [user]
                newArray.updateValue(newValue, forKey: firstChar)
                continue
            }
            array.append(user)
            newArray.updateValue(array, forKey: firstChar)
        }
        return newArray
    }
    
    /// Переопределим словарь друзей в [FriendSection]
    func formFriendSection(_ array: [Character: [Friends]]) -> [FriendSection] {
        var sectionArray: [FriendSection] = []
        for (key, array) in array {
            sectionArray.append(FriendSection(key: key, data: array))
        }
        sectionArray.sort {$0 < $1}
        return sectionArray
    }
    
    /// Фильтруем друзей в [FriendSection]
    func formFriendArray(from array: [Friends]) -> [FriendSection] {
        let sortDictionary = sortFriends(array)
        let sortArray = formFriendSection(sortDictionary)
        return sortArray
    }
    
    /// Заголовки секций
    func loadLetter() -> Void {
        arrayLettersOfNames = arrayFriend.map { String($0.key) }
    }
    
    /// Запрос на сервер
    func getListMyfriend(complition: @escaping ([FriendSection]) -> Void) {
        loadFriends.loadListFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let myFriends):
                let sortedFriend = self.formFriendArray(from: myFriends)
                complition(sortedFriend)
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension MyFriendViewModel: MyFriendViewModelInput {
    
    /// Фильтрация друзей в SearchBar
    func serachBarFiltered(searchText: String) -> Void {
        arrayFilteredFriendData = []
        if searchText == "" {
            arrayFilteredFriendData = arrayFriend
        } else {
            for section in arrayFriend {
                for (_, friend) in section.data.enumerated() {
                    if friend.firstName.lowercased().contains(searchText.lowercased()) {
                        var searchedSection = section
                        if arrayFilteredFriendData.isEmpty {
                            searchedSection.data = [friend]
                            arrayFilteredFriendData.append(searchedSection)
                            break
                        }
                        var faind = false
                        for (sectionIndex, filteredSection) in arrayFilteredFriendData.enumerated() {
                            if filteredSection.key == section.key {
                                arrayFilteredFriendData[sectionIndex].data.append(friend)
                                faind = true
                                break
                            }
                        }
                        if !faind {
                            searchedSection.data = [friend]
                            arrayFilteredFriendData.append(searchedSection)
                        }
                    }
                }
            }
        }
    }
}

