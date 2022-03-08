//
//  TabBarViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit
// MARK: - TabBarController
final class TabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = .white
        setupViewControllers()
    }
    
    /// Cоздаём и конфигурируем Navigation Контроллеры, которые будут отображены в табах
    private func setupViewControllers() {
        guard let imageMyFriend = UIImage(systemName: "person.fill") else { return }
        guard let imagemyGroup = UIImage(systemName: "person.3.fill") else { return }
        guard let imageNews = UIImage(systemName: "newspaper.fill") else { return }
        
        let myFriendViewModel = MyFriendViewModel()
        let myGroupViewModel = MyGroupViewModel()
        let newsViewModel = NewsViewModel()
        
        let myFriend = createNavController(for: MyFriendsViewController(viewModel: myFriendViewModel), title: "Мои Друзья", image: imageMyFriend)
        let myGroup = createNavController(for: MyGroupViewController(viewModel: myGroupViewModel), title: "Мои Группы", image: imagemyGroup)
        let myNews = createNavController(for: NewsViewController(viewModel: newsViewModel), title: "Мои Новости", image: imageNews)
        
        viewControllers = [myFriend, myGroup, myNews]
    }
    
    ///  Определим метод для настройки NavigationControler-ов
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        rootViewController.navigationItem.backButtonTitle = ""
        rootViewController.view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        navController.navigationBar.backgroundColor = .white
        return navController
    }
}
