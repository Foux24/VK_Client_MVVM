//
//  NewsCollectionImageCollectionViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import UIKit

class NewsCollectionImageCollectionViewCell: UICollectionViewCell {
    
    /// Ключ для регистрации ячкйки
    static let reuseID = String(describing: NewsCollectionImageCollectionViewCell.self)
    
    /// UIImage
    let photoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    /// Конфигурирует ячейку
    func configureImage(with image: UIImage?) {
        contentView.addSubview(photoView)
        photoView.image = image
        setupConstraints()
    }
    
    /// Установка констрейнтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
