//
//  VKAuthorisationViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit
import WebKit

// MARK: -  VKAuthorisationViewController
final class VKAuthorisationViewController: UIViewController {
    
    /// Ссылка на класс сессии
    private let session = Session.instance
    
    /// Ссылка на вью модель
    private let viewModel: VKAuthorisationViewModelOutout
    
    /// Инициализтор
    init(viewModel: VKAuthorisationViewModelOutout) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Вью для отображения
    private var webView: VKAuthoristionView {
        return self.view as! VKAuthoristionView
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        super.loadView()
        self.view = VKAuthoristionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        viewModel.loadLoginVK { [weak self] request in
            self?.webView.webView.load(request)
        }
        setupWebView()
    }
}

// MARK: - Extension WK Delegate
extension VKAuthorisationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0 .components(separatedBy: "=")}
            .reduce ([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"], let userId = params["user_id"] {
            
            session.token = token
            session.userId = Int(userId) ?? 0
            
            print(token)
            print(userId)
            
            decisionHandler(.cancel)
            transitNextController()
        }
    }
}

// MARK: - Private
private extension VKAuthorisationViewController {
    
    /// Назначим делегата веб вью
    func setupWebView() {
        self.webView.webView.navigationDelegate = self
    }
    
    /// Переход на следующий экран
    func transitNextController() -> Void {
        self.navigationController?.pushViewController(TabBarController(), animated: true)
    }
}
