//
//  SceneDelegate.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow? {
        didSet {
            /// Выключим темный режим
            window?.overrideUserInterfaceStyle = .light
        }
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        
        let vkAuthorisationViewModel = VKAuthorisationViewModel()
        let authorisationViewController = VKAuthorisationViewController(viewModel: vkAuthorisationViewModel)
        let navigationController = UINavigationController(rootViewController: authorisationViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        guard let _ = (scene as? UIWindowScene) else {return}
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

