//
//  AllPhotoFriendCollectionViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 06.03.2022.
//

import UIKit

final class AllPhotoFriendCollectionViewCell: UICollectionViewCell {
    
    /// Ключ для регистрации ячкйки
    static let reuseID = String(describing: AllPhotoFriendCollectionViewCell.self)

    /// UIImage
    private(set) lazy var photoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    /// Конфигурирует ячейку
    func configureImage(with image: UIImage?) {
        guard let imageDefault = UIImage(systemName: "photo") else { return }
        photoView.image = image ?? imageDefault
        setupUIImage()
        setupConstraints()
    }
    
}

// MARK: - Private
private extension AllPhotoFriendCollectionViewCell {
    
    /// Метод  добавления UIImage в ячейку
    func setupUIImage() {
        contentView.addSubview(photoView)
    }
    
    /// Метод установки констрейнтов
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
