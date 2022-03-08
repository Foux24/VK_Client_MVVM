//
//  RequestServerMyFriend.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import Foundation

// MARK: - Request Friend Vk.API
// создадим енум-кейс с типами запросов
fileprivate enum TypeMethods: String {
    case friendsGet = "/method/friends.get"
    case friendsSearch = "/method/friends.search"
}

// Создадим список типов запросов
fileprivate enum TypeRequest: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Error
// создадим енум с возможными ошибками
enum FriendsError: Error {
    case parseError
    case requestError(Error)
}


// MARK: - Основа для запроса на сервер
final class RequestServerMyFriend {
    
    // Определим сессию с конфигуратором
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    // Протокол запроса
    private let scheme = "https"
    
    // Адресс сервера
    private let host = "api.vk.com"
    
    // Вид Декодера
    private let decoder = JSONDecoder()
    
    // MARK: - Запрос на сервер
    /// Метод получения списка друзей
    func loadListFriends(completion: @escaping (Result<[Friends], FriendsError>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [self] in
            
            guard let token = Session.instance.token else { return }
            let params: [String: String] = ["fields" : "photo_200_orig,status,domain,last_seen"]
            let url = configureUrl(token: token,
                                   method: .friendsGet,
                                   httpMethod: .get,
                                   params: params)
            print(url)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    return completion(.failure(.requestError(error)))
                }
                guard let data = data else { return }
                do {
                    let result = try self.decoder.decode(FriendsList.self, from: data)
                    
                    DispatchQueue.main.async {
                        return completion(.success(result.response.items))
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

private extension RequestServerMyFriend {
    /// Метод для конфигурации URL
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
