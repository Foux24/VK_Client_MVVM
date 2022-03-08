//
//  VKAuthorisationViewModel.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

protocol VKAuthorisationViewModelOutout: AnyObject {
    func loadLoginVK(comlition: @escaping (URLRequest) -> Void)
}

final class VKAuthorisationViewModel: VKAuthorisationViewModelOutout {
    
    /// Свойство для контроллера
    weak var viewInput: UIViewController?
    
    func loadLoginVK(comlition: @escaping (URLRequest) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8002144"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html" ),
            URLQueryItem(name: "scope", value: "offline, friends, photos, groups, wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "0")
        ]
        let request = URLRequest(url: urlComponents.url!)
        comlition(request)
    }
}
