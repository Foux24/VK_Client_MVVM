//
//  RequestServerNews.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import Foundation

// MARK: - Request Friend Vk.API
// создадим енум-кейс с типами запросов
fileprivate enum TypeMethods: String {
    case newsGetAll = "/method/newsfeed.get"
    case likeAddPost = "/method/likes.add"
    case likeRemovePost = "/method/likes.delete"
}

// Создадим список типов запросов
fileprivate enum TypeRequest: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Protocols

protocol NewsServiceInterface {
    func loadNews(nextFrom: String, startTime: Double?, completion: @escaping (Result<Response, NewsError>) -> Void)
    func addLikeNewsPost(ownerID: Int, postID: Int, completion: @escaping (Result<AddOrDeletLikePost, GroupServiceError>) -> Void)
    func removeLikeNewsPost(ownerID: Int, postID: Int, completion: @escaping (Result<AddOrDeletLikePost, GroupServiceError>) -> Void)
}

// MARK: - Error
// создадим енум с возможными ошибками
enum NewsError: Error {
    case parseError
    case requestError(Error)
}

// MARK: - Основа для запроса на сервер
final class RequestServerNews: NewsServiceInterface {
    
    // создадим собственную сессию в которой определим конфигурацию запроса по дефолту
    private let session: URLSession = {
        // конфиг по дефолту
        let config = URLSessionConfiguration.default
        // с собственная сессия с конфигурацией
        let session = URLSession(configuration: config)
        // возвращаем константу сессия
        return session
    }()
    
    // определим по какому протоколу будем делать запрос
    private let scheme = "https"
    
    // определим адресс сервера
    private let host = "api.vk.com"
    
    // определим в каком формате нам нужно вернуть данные
    private let decoder = JSONDecoder()
    
    // MARK: - Запросы на сервер

    /// Загрузка новостей
    func loadNews(nextFrom: String = "", startTime: Double? = nil, completion: @escaping (Result<Response, NewsError>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [self] in
            guard let token = Session.instance.token else { return }
            var params: [String: String] = ["source_ids" : "friends,groups",
                                            "count" : "20",
                                            "filters" : "photo,post",
                                            "start_from" : nextFrom
            ]
            if let startTime = startTime {
                params["start_time"] = "\(startTime)"
            }
            let url = configureUrl(token: token,
                                   method: .newsGetAll,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(News.self, from: data)
                    DispatchQueue.main.async {
                        return completion(.success(result.response))
                    }
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
        }
    }
    
    /// Поставка лайка
    func addLikeNewsPost(ownerID: Int,
                         postID: Int,
                         completion: @escaping (Result<AddOrDeletLikePost, GroupServiceError>) -> Void) {
        
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["type" : "post",
                                        "owner_id" : "\(ownerID)",
                                        "item_id" : "\(postID)"
        ]
        let url = configureUrl(token: token,
                               method: .likeAddPost,
                               httpMethod: .post,
                               params: params)
        
        print(url)
        DispatchQueue.global(qos: .utility).async { [self] in
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(LikePost.self, from: data)
                    DispatchQueue.main.async {
                        return completion(.success(result.response))
                    }
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
        }
    }
    
    /// Удаление лайка
    func removeLikeNewsPost(ownerID: Int,
                            postID: Int,
                            completion: @escaping (Result<AddOrDeletLikePost, GroupServiceError>) -> Void) {
        
        guard let token = Session.instance.token else { return }
        let params: [String: String] = ["type" : "post",
                                        "owner_id" : "\(ownerID)",
                                        "item_id" : "\(postID)"
        ]
        let url = configureUrl(token: token,
                               method: .likeRemovePost,
                               httpMethod: .post,
                               params: params)
        print(url)
        DispatchQueue.global(qos: .utility).async { [self] in
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(LikePost.self, from: data)
                    DispatchQueue.main.async {
                        return completion(.success(result.response))
                    }
                } catch {
                    return completion(.failure(.parseError))
                }
            }
            task.resume()
        }
    }
}

// MARK: - Private
// расширим класс для определения модели конфигурации УРЛ
private extension RequestServerNews {
    func configureUrl(token: String,
                      method: TypeMethods,
                      httpMethod: TypeRequest,
                      params: [String: String]) -> URL {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "access_token", value: token))
        queryItems.append(URLQueryItem(name: "v", value: "5.81"))
        for (param, value) in params {
            queryItems.append(URLQueryItem(name: param, value: value))
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            fatalError("URL is invalid")
        }
        return url
    }
}

// MARK: - Interface Proxy
class RequestServerNewsLoggingProxy: NewsServiceInterface {

    /// ссылка на сервис
    let newsService: NewsServiceInterface
    
    /// Инициализтор
    init(newsService: NewsServiceInterface) {
        self.newsService = newsService
    }
    
    // Хм... патерн логирование, но тот же Interactor 
    /// Логирование
    func loadNews(nextFrom: String = "", startTime: Double? = nil, completion: @escaping (Result<Response, NewsError>) -> Void) {
        newsService.loadNews(nextFrom: nextFrom, startTime: startTime, completion: completion)
        print("Запрос на загрузку новостей создан")
    }
    
    func addLikeNewsPost(ownerID: Int, postID: Int, completion: @escaping (Result<AddOrDeletLikePost, GroupServiceError>) -> Void) {
        newsService.addLikeNewsPost(ownerID: ownerID, postID: postID, completion: completion)
        print("Запрос на лайк создан")
    }
    
    func removeLikeNewsPost(ownerID: Int, postID: Int, completion: @escaping (Result<AddOrDeletLikePost, GroupServiceError>) -> Void) {
        newsService.removeLikeNewsPost(ownerID: ownerID, postID: postID, completion: completion)
        print("Запрос на удаления лайка создан")
    }
}
