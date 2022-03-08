//
//  CardMyFriendView.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 06.03.2022.
//

import UIKit

final class CardMyFriendView: UIView {
    
    /// avatar Friend
    private(set) lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 35
        return image
    }()
    
    /// Name Friend
    private(set) lazy var nameFriendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    /// Status Label
    private(set) lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    /// Status Label
    private(set) lazy var statusTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    /// Photo
    private(set) lazy var photoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.text = "ФОТОГРАФИИ"
        return label
    }()
    
    /// Count Photo
    private(set) lazy var countPhotoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .left
        return label
    }()
    
    /// UICollectionView
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    /// инициализтор
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstreints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Конфигуратор данных для UI
    func configurationUI(image: String, name: String, status: String, time: String) {
        avatarImage.loadImage(image)
        nameFriendLabel.text = name
        statusLabel.text = status
        statusTime.text = "Был(а) в сети в \(time)"
    }
}


private extension CardMyFriendView {
    
    /// Добавление и настройка UI
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(avatarImage)
        self.addSubview(nameFriendLabel)
        self.addSubview(statusLabel)
        self.addSubview(statusTime)
        self.addSubview(photoLabel)
        self.addSubview(countPhotoLabel)
        self.addSubview(collectionView)
    }
    
    /// Задаём констрейнты
    func setupConstreints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            avatarImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            nameFriendLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            nameFriendLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            nameFriendLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            statusLabel.topAnchor.constraint(equalTo: nameFriendLabel.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            statusTime.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
            statusTime.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 10),
            statusTime.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            photoLabel.topAnchor.constraint(equalTo: self.avatarImage.bottomAnchor, constant: 10),
            photoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            countPhotoLabel.topAnchor.constraint(equalTo: photoLabel.topAnchor),
            countPhotoLabel.leadingAnchor.constraint(equalTo: photoLabel.trailingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// Настроим композицию элементов в коллекции
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 5
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
