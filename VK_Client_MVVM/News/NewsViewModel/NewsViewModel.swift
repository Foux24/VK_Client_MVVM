//
//  NewsViewModel.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import UIKit

/// С формуируем автора новости
struct AuthorNewsModel {
    var name: String = ""
    var avatarURL: String = ""
    var id: Int = 0
}

protocol NewsViewModelOutput: AnyObject {
    var height: Int { get set }
    var width: Int { get set }
    var defaultImage: UIImage { get set }
    var serviceProxy: RequestServerNewsLoggingProxy { get set }
    var nextFrom: String { get set }
    var isLoading: Bool { get set }
    var news: [MyNews] { get set }
    var fileManager: HashPhotoService? { get set }
    func loadNews() -> Void
    func reloadNews(tableView: UITableView) -> Void
    func loadNewNews(indexPaths: [IndexPath], tableView: UITableView) -> Void
    func sortNews(arrayNews: [MyNews]) -> [MyNews]
    func formateDate(date: Double) -> String
    func getOwnerNews(news: MyNews) -> AuthorNewsModel
    func collectionPhotoTableView(newsResponse: MyNews) -> [String]
}

final class NewsViewModel: NewsViewModelOutput {
    
    /// Высота коллекции с картинками
    var height: Int = 0
    
    /// ширина коллекции с картинками
    var width: Int = 0
    
    /// Для запроса дополнительных новостей
    var nextFrom: String = ""
    
    /// Массив новостей
    var news = [MyNews]()
    
    /// Массив груп
    var groups = [GroupNews]()
    
    /// Масив профилей
    var profiles = [ProfileNews]()
    
    /// Default Image
    var defaultImage: UIImage = UIImage(systemName: "photo")!
    
    /// Для метки загрузки следующих новостей
    var isLoading: Bool = false
    
    /// Hash Image
    var fileManager: HashPhotoService?
    
    /// Ссылка на сервис по логированию
    var serviceProxy = RequestServerNewsLoggingProxy(newsService: RequestServerNews())
    
    /// Определим формат преобразования даты
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        df.locale = Locale(identifier: "ru_RU")
        df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return df
    }()
    
    /// Метод сортировки новостей
    func sortNews(arrayNews: [MyNews]) -> [MyNews] {
        var filterNews: [MyNews] = []
        for news in arrayNews {
            if news.attachments != nil {
                filterNews.append(news)
            }
        }
        return filterNews
    }
    
    /// Метод для конвертации даты
    func formateDate(date: Double) -> String {
        var dateFormate = ""
        let date = NSDate(timeIntervalSince1970: TimeInterval(date))
        let dateString = self.dateFormatter.string(from: date as Date)
        dateFormate = dateString
        return dateFormate
    }
    
    /// Метод загрузки новостей
    func loadNews() -> Void {
        serviceProxy.loadNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.news = self.sortNews(arrayNews: news.items)
                self.groups = news.groups
                self.profiles = news.profiles
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Метод сортировки авторов новости
    func getOwnerNews(news: MyNews) -> AuthorNewsModel {
        var authorNews = AuthorNewsModel()
        if news.sourceID >= 0 {
            for profile in self.profiles {
                if news.sourceID == profile.id {
                    authorNews.name = "\(profile.firstName) \(profile.lastName)"
                    authorNews.avatarURL = profile.photo100
                    authorNews.id = profile.id
                }
            }
        } else {
            let sourceID = news.sourceID * -1
            for group in self.groups {
                if group.id == sourceID {
                    authorNews.name = group.name
                    authorNews.avatarURL = group.photo100
                    authorNews.id = group.id
                }
            }
        }
        return authorNews
    }
    
    /// Загрузка новых новостей
    func reloadNews(tableView: UITableView) -> Void {
        tableView.refreshControl?.beginRefreshing()
        let mostFreshNewsDate = self.news.first?.date ?? Date().timeIntervalSince1970
        serviceProxy.loadNews(startTime: mostFreshNewsDate + 1) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let news):
                let filterNews = self.sortNews(arrayNews: news.items)
                tableView.refreshControl?.endRefreshing()
                guard filterNews.count > 0 else {return}
                self.news = filterNews + self.news
                self.profiles.append(contentsOf: news.profiles)
                self.groups.append(contentsOf: news.groups)
                let indexSet = IndexSet(integersIn: 0..<filterNews.count)
                tableView.insertSections(indexSet, with: .automatic)
            case .failure(let error):
                DispatchQueue.main.async {
                    tableView.refreshControl?.endRefreshing()
                }
                print(error)
            }
        }
    }
    
    /// Подгрузка новых новостей в клнец списка
    func loadNewNews(indexPaths: [IndexPath], tableView: UITableView) -> Void {
        guard let maxSection = indexPaths.map({$0.section}).max() else {return}
        if maxSection > news.count - 3,
           !isLoading {
            isLoading = true
            serviceProxy.loadNews(nextFrom: nextFrom) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let self = self else {return}
                    let indexSet = IndexSet(integersIn: self.news.count ..< self.news.count + self.sortNews(arrayNews: response.items).count)
                    self.news.append(contentsOf: self.sortNews(arrayNews: response.items))
                    self.nextFrom = response.nextFrom!
                    self.profiles.append(contentsOf: response.profiles)
                    self.groups.append(contentsOf: response.groups)
                    tableView.insertSections(indexSet, with: .automatic)
                    self.isLoading = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    /// Выдернем по типу photo наши обьекты с картинки новостей
    func attachmentsInPurplePhoto(attachments: [ItemAttachment]) -> [PurplePhoto] {
        var arrayPhoto: [PurplePhoto] = []
        for type in attachments {
            if type.type == "photo" {
                arrayPhoto.append(type.photo!)
            }
        }
        return arrayPhoto
    }
    
    /// Выдернем по типу video наши обьекты с видео
    func attachmentsInVideoImage(attachments: [ItemAttachment]) -> [VideoElement] {
        var arrayImageVideo: [VideoElement] = []
        for type in attachments {
            if type.type == "video" {
                arrayImageVideo.append(type.video!)
            }
        }
        return arrayImageVideo
    }
    
    /// Выдернем URL из масива с photo в один масив
    func PhotoInArrayURL(arrayPhoto: [PurplePhoto]) -> [String] {
        var arrayURL: [String] = []
        for photo in arrayPhoto {
            var array: [String] = []
            for size in photo.sizes {
                array.append(size.url)
            }
            arrayURL.append(array.last!)
        }
        return arrayURL
    }
    
    /// Выдернем URL и по нему добавим размер из масива с photo в один масив
    func PhotoInArrayURLSizeHeight(arrayHeight: [PurplePhoto]) -> [Int] {
        var arrayURLHeight: [Int] = []
        for photo in arrayHeight {
            var array: [Int] = []
            for size in photo.sizes {
                array.append(size.height)
            }
            arrayURLHeight.append(array.last!)
        }
        return arrayURLHeight
    }
    
    /// Выдернем URL и по нему добавим размер из масива с photo в один масив
    func PhotoInArrayURLSizeWidht(arrayWidht: [PurplePhoto]) -> [Int] {
        var arrayURLWidht: [Int] = []
        for photo in arrayWidht {
            var array: [Int] = []
            for size in photo.sizes {
                array.append(size.width)
            }
            arrayURLWidht.append(array.last!)
        }
        return arrayURLWidht
    }
    
    /// Выдернем превью видео в массив
    func VideoInArrayURL(arrayVideo: [VideoElement]) -> [String] {
        var arrayURL: [String] = []
        for video in arrayVideo {
            arrayURL.append(video.photo800)
        }
        return arrayURL
    }
    
    /// Метод конфигурации ячейки с коллекцией картинок для новостей TableView
    func collectionPhotoTableView(newsResponse: MyNews) -> [String] {
        var filteredPhotoCoillection = [String]()
        var arrayPhotoCollection: [String] = []
        let arrayAttachments = attachmentsInPurplePhoto(attachments: newsResponse.attachments!)
        let arrayPhoto = PhotoInArrayURL(arrayPhoto: arrayAttachments)
        let arrayWidht = PhotoInArrayURLSizeWidht(arrayWidht: arrayAttachments)
        let arrayHeight = PhotoInArrayURLSizeHeight(arrayHeight: arrayAttachments)
        arrayPhotoCollection += arrayPhoto
        self.width = arrayWidht.first ?? 0
        self.height = arrayHeight.first ?? 0
        let arrayAttachment = attachmentsInVideoImage(attachments: newsResponse.attachments!)
        let arrayImageVideo = VideoInArrayURL(arrayVideo: arrayAttachment)
        arrayPhotoCollection += arrayImageVideo
        if arrayImageVideo.isEmpty == false {
            self.width = 800
            self.height = 800
        }
        if arrayPhotoCollection.count > 4 {
            filteredPhotoCoillection = arrayPhotoCollection.suffix(4)
        }else if arrayPhotoCollection.count < 5 {
            filteredPhotoCoillection = arrayPhotoCollection
        }
        return filteredPhotoCoillection
    }
}
