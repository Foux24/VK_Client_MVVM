//
//  MyGroupTableViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import UIKit

final class MyGroupTableViewCell: UITableViewCell {
    
    /// Ключ для регистрации ячкйки
    static let reuseID = String(describing: MyGroupTableViewCell.self)
    
    /// Label с именем группы
    let nameGroupLabel: UILabel = {
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
    let iconGroupLabel: CastomAvatarImage = {
        let image = CastomAvatarImage()
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Метод конфигурации ячейки
    func configuration(nameGroup: String, iconGroup: UIImage) {
        nameGroupLabel.text = nameGroup
        iconGroupLabel.image = iconGroup
        setupUIElement()
        setupConstaints()
    }
}

// MARK: - PrivateSetup
private extension MyGroupTableViewCell {
    
    /// Установка UI
    func setupUIElement() {
        contentView.backgroundColor = .white
        contentView.addSubview(nameGroupLabel)
        contentView.addSubview(iconGroupLabel)
    }
    
    /// Eстановка констрейнтов
    func setupConstaints() {
        NSLayoutConstraint.activate([
            nameGroupLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameGroupLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconGroupLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            iconGroupLabel.leadingAnchor.constraint(equalTo: nameGroupLabel.trailingAnchor, constant: 5),
            iconGroupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            iconGroupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            iconGroupLabel.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}
