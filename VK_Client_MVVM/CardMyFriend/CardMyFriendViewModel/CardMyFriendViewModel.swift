//
//  CardMyFriendViewModel.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 06.03.2022.
//

import UIKit


protocol CardMyFriendViewModelOutput: AnyObject {
    var arrayURLSizeZ: [String] { get set }
    var defaultCountSection: Int { get set }
    func formateDate(date: Double) -> String
    func fetchPhotos(idFriend: Int, completion: @escaping () -> Void)
}


final class CardMyFriendViewModel: CardMyFriendViewModelOutput {
    
    /// Массив фильтрованых УРЛ размером М
    var arrayURLSizeZ = [String]()
    
    /// Ссылка на class по загрузке списка друзей
    let loadPhoto = RequestServerPhotoMyFriend()
    
    var defaultCountSection: Int = 1
    
    /// Определим формат преобразования даты
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        df.locale = Locale(identifier: "ru_RU")
        df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return df
    }()
    
    /// Метод для конвертации даты
    func formateDate(date: Double) -> String {
        var dateFormate = ""
        let date = NSDate(timeIntervalSince1970: TimeInterval(date))
        let dateString = self.dateFormatter.string(from: date as Date)
        dateFormate = dateString
        return dateFormate
    }
    
    /// Метод сортировки фото по передаваемому типу
    func sortImage(by sizeType: Size.EnumType, from array: [PhotoFriend]) -> [String] {
        var imageLinks: [String] = []
        for model in array {
            for size in model.sizes {
                if size.type == sizeType {
                    imageLinks.append(size.url)
                }
            }
        }
        return imageLinks
    }
    
    /// Определим метод для загрузки фото с сервера
    func fetchPhotos(idFriend: Int, completion: @escaping () -> Void) {
        /// Вызовем метод загрузки фото с сервера
        loadPhoto.loadPhoto(idFriend: String(idFriend)) { [weak self] model in
            guard let self = self else { return }
            switch model {
            case .success(let friendPhoto):
                self.arrayURLSizeZ = self.sortImage(by: .z, from: friendPhoto)
                completion()
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
