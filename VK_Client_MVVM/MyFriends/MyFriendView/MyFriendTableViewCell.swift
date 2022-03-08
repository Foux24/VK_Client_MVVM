//
//  MyFriendTableViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

final class MyFriendTableViewCell: UITableViewCell {
    
    /// Ключ для регистрации ячкйки
    static let reuseID = String(describing: MyFriendTableViewCell.self)
    
    /// Label с именем группы
    let nameFriend: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "name group"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    /// Логотип группы
    let avatarFriend: CastomAvatarImage = {
        let image = CastomAvatarImage()
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Метод конфигурации ячейки
    func configuration(name: String, avatar: UIImage) {
        nameFriend.text = name
        avatarFriend.image = avatar
        setupUIElement()
        setupConstaints()
        animate()
    }
}

// MARK: - PrivateSetup
private extension MyFriendTableViewCell {
    
    /// Установка UI
    func setupUIElement() {
        contentView.backgroundColor = .white
        contentView.addSubview(nameFriend)
        contentView.addSubview(avatarFriend)
    }
    
    /// Eстановка констрейнтов
    func setupConstaints() {
        NSLayoutConstraint.activate([
            nameFriend.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameFriend.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            avatarFriend.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            avatarFriend.leadingAnchor.constraint(equalTo: nameFriend.trailingAnchor, constant: 5),
            avatarFriend.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            avatarFriend.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            avatarFriend.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    

}

// MARK: Private Animate
private extension MyFriendTableViewCell {
    
    // запускаем анимацию ячейки при появлении
    func animate() {
        self.avatarFriend.alpha = 0
        self.frame.origin.x += 100
        
            UIView.animate(withDuration: 0.3,
                           delay: 0.15,
                           options: [],
                           animations: {
                self.avatarFriend.alpha = 1
            })
            
            UIView.animate(withDuration: 0.4,
                           delay: 0.1,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                self.frame.origin.x = 0
            })
    }
}
