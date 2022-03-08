//
//  RequestServerGroup.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

// группа запросов на сервер касающихся групп
import Foundation
import PromiseKit

// MARK: - Методы и типы запросов
// енум кейс для подставки методов(видов) запросов на сервер ВК
fileprivate enum TypeMethods: String {
   case groupsGet = "/method/groups.get"
   case groupsSearch = "/method/groups.search"
   case groupsJoin = "/method/groups.join"
   case groupsLeave = "/method/groups.leave"
}

// тип запросов Get - отправить - принять ответ, POST - отправить - записать на сервер
fileprivate enum TypeRequest: String {
   case get = "GET"
   case post = "POST"
}

// MARK: - Ошибки
// кейсы с ошибками
enum GroupServiceError: Error {
    case parseError
    case requestError(Error)
    case notCorrectURL
    case errorTask
}

// MARK: - Класс основа для запроса на сервер
final class RequestServerGroup {
    
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
    
}

// MARK: - Private
// расширим класс для определения модели конфигурации УРЛ
private extension RequestServerGroup {
    
   /// Конфигуратор УРЛ
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

// MARK: - Запросы на сервер
// MARK: - Extension PromiseKit LoadGroup
extension RequestServerGroup {
    /// Метод конфигурации УРЛ
    func loadGroupPromisURL() -> Promise<URL> {
        
        let token = Session.instance.token ?? ""
        
        let params: [String: String] = ["extended" : "1"]
        let urlConfig = self.configureUrl(token: token,
                                          method: .groupsGet,
                                          httpMethod: .get,
                                          params: params)
        print(urlConfig)
        return Promise { resolver in
            let url = urlConfig
            resolver.fulfill(url)
        }
    }
    
    /// Метод Конфигурации ответа от сервера в дату
    func loadGroupPromisData(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    resolver.reject(GroupServiceError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    /// Метод парсинга
    func loadGroupPromiseParsed(_ data: Data) -> Promise<[Group]> {
        return Promise { resolver in
            do {
                let response = try decoder.decode(Groups.self, from: data).response.items
                resolver.fulfill(response)
            } catch {
                resolver.reject(GroupServiceError.parseError)
            }
        }
    }
}


// MARK: - Extension PromiseKit DeletGroup
extension RequestServerGroup {
    
    /// Конфигуратор УРЛ для удаления группы
    func deleteGroupPromisURL(id: Int) -> Promise<URL> {
        
        let token = Session.instance.token ?? ""
        let params: [String: String] = ["group_id" : "\(id)"]
        let urlConfig = self.configureUrl(token: token,
                                          method: .groupsLeave,
                                          httpMethod: .post,
                                          params: params)
        print(urlConfig)
        return Promise { resolver in
            let url = urlConfig
            resolver.fulfill(url)
        }
    }
    
    /// Метод Конфигурации ответа от сервера в дату
    func deleteGroupPromisData(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    resolver.reject(GroupServiceError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    /// Метод парсинга
    func deleteGroupPromiseParsed(_ data: Data) -> Promise<JoinOrLeaveGroupModel> {
        return Promise { resolver in
            do {
                let response = try self.decoder.decode(JoinOrLeaveGroupModel.self, from: data)
                resolver.fulfill(response)
            } catch {
                resolver.reject(GroupServiceError.parseError)
            }
        }
    }
}

// MARK: - Extension PromiseKit AddGroup
extension RequestServerGroup {
    
    /// Конфигуратор УРЛ для удаления группы
    func addGroupPromisURL(id: Int) -> Promise<URL> {
        
        let token = Session.instance.token ?? ""
        let params: [String: String] = ["group_id" : "\(id)"]
        let urlConfig = self.configureUrl(token: token,
                                          method: .groupsJoin,
                                          httpMethod: .post,
                                          params: params)
        print(urlConfig)
        return Promise { resolver in
            let url = urlConfig
            resolver.fulfill(url)
        }
    }
    
    /// Метод Конфигурации ответа от сервера в дату
    func addGroupPromisData(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    resolver.reject(GroupServiceError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    /// Метод парсинга
    func addGroupPromiseParsed(_ data: Data) -> Promise<JoinOrLeaveGroupModel> {
        return Promise { resolver in
            do {
                let response = try self.decoder.decode(JoinOrLeaveGroupModel.self, from: data)
                resolver.fulfill(response)
            } catch {
                resolver.reject(GroupServiceError.parseError)
            }
        }
    }
}

// MARK: - Extension PromiseKit SearchGroup
extension RequestServerGroup {
    
    /// Конфигуратор УРЛ для поиска группы
    func searchGroupPromisURL(searchText: String) -> Promise<URL> {
        
        let token = Session.instance.token ?? ""
        let params: [String: String] = ["extended" : "1",
                                        "q" : searchText,
                                        "count" : "40"]
        
        let urlConfig = self.configureUrl(token: token,
                                          method: .groupsSearch,
                                          httpMethod: .get,
                                          params: params)
        print(urlConfig)
        return Promise { resolver in
            let url = urlConfig
            resolver.fulfill(url)
        }
    }
    
    /// Метод Конфигурации ответа от сервера в дату
    func searchGroupPromisData(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    resolver.reject(GroupServiceError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    /// Метод парсинга
    func searchGroupPromiseParsed(_ data: Data) -> Promise<[Group]> {
        return Promise { resolver in
            do {
                let response = try self.decoder.decode(Groups.self, from: data).response.items
                resolver.fulfill(response)
            } catch {
                resolver.reject(GroupServiceError.parseError)
            }
        }
    }
}
