//
//  NewsHeaderTableViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import UIKit

// MARK: - CellAuthorNews
/// Опредлим класс с первой по счету ячейки в нашей таблице
class NewsHeaderTableViewCell: UITableViewCell {
    
    static let reuseID = String(describing: NewsHeaderTableViewCell.self)
    
    /// Avatar
    private var avatarOwnerNews: CastomAvatarImage = {
        let image = CastomAvatarImage()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Name Owner News
    private let nameOwnerNews: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    /// Date Public
    private let dateNews: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    ///  Определим метод для конфигурации нашей учеки
    func configuration(nameAvtor name: String, dateNews date: String, avatarAvtor avatar: UIImage ) {
        nameOwnerNews.text = name
        dateNews.text = date
        avatarOwnerNews.image = avatar
        setupCollectionCell()
        setupConstreints()
    }
}

// MARK: - private
private extension NewsHeaderTableViewCell {
    
    /// Add UIElements in CollectionViewCell
    func setupCollectionCell() {
        contentView.backgroundColor = .white
        contentView.addSubview(avatarOwnerNews)
        contentView.addSubview(nameOwnerNews)
        contentView.addSubview(dateNews)
    }
    
    /// Setup Constreints UIElement
    func setupConstreints() {
        NSLayoutConstraint.activate([

            avatarOwnerNews.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarOwnerNews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            avatarOwnerNews.widthAnchor.constraint(equalToConstant: 60),
            avatarOwnerNews.heightAnchor.constraint(equalToConstant: 60),

            nameOwnerNews.topAnchor.constraint(equalTo: avatarOwnerNews.topAnchor, constant: 10),
            nameOwnerNews.leadingAnchor.constraint(equalTo: avatarOwnerNews.trailingAnchor, constant: 20),
            nameOwnerNews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            dateNews.topAnchor.constraint(equalTo: nameOwnerNews.bottomAnchor, constant: 8),
            dateNews.leadingAnchor.constraint(equalTo: avatarOwnerNews.trailingAnchor, constant: 20),
            avatarOwnerNews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
}
