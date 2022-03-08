//
//  NewsCollectionImageTableViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import UIKit

// MARK: - CellImages
class NewsCollectionImageTableViewCell: UITableViewCell {
    
    /// Для регистрации ячейки в таблице
    static let reuseID = String(describing: NewsCollectionImageCollectionViewCell.self)
    
    /// UICollectionView - для Коллекции фото и картинок
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    /// property for sorted Image type
    var sortedImageFinal: [String] = []

    /// Для кеша изоборажений
    private var fileManager: HashPhotoService?
    
    /// Метод для конфигурации ячейки с коллекцией
    func configuration(collectionPhoto: [String]) {
        fileManager = HashPhotoService(container: collectionView)
        sortedImageFinal = collectionPhoto
        collectionView.reloadData()
        setupCollectionView()
        setupConstreints()
    }
}

// MARK: - extension CellImages
extension NewsCollectionImageTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Нативный метод для определения кол-ва секци
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// Нативный метод для определения кол-ва итемов коллекции в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedImageFinal.count
    }
    
    /// Нативный метод для конфигурации ячейки в коллекции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NewsCollectionImageCollectionViewCell
        let image = fileManager?.photo(atIndexPath: indexPath, byUrl: sortedImageFinal[indexPath.item])
        cell.configureImage(with: image)
        return cell
    }
}

//MARK: - Private
private extension NewsCollectionImageTableViewCell {
    
    /// Setup Constreints UIElement
    func setupConstreints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    /// Configuration CollectionView add in ViewController
    func setupCollectionView() {
        collectionView.collectionViewLayout = creatLayout(countPhoto: sortedImageFinal.count)
        collectionView.registerCell(NewsCollectionImageCollectionViewCell.self)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        self.contentView.addSubview(collectionView)
    }
}



// MARK: - extension CellImages
extension NewsCollectionImageTableViewCell {
    
    /// А метод определения вида коллекции по переданному количеству фото в новости
    func creatLayout(countPhoto count: Int) -> UICollectionViewLayout {
        switch count {
        case 2:
            return creatLayuotTwoPhoto()
        case 3:
            return creatLayuotThreePhoto()
        case 4:
            return creatLayuotForPhoto()
        default:
            return creatLayuotOnePhoto()
        }
    }
    
    /// Метод для постановки компазии для одной фото в новости
    func creatLayuotOnePhoto() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    /// Метод для постановки компазии для двух фото в новости
    func creatLayuotTwoPhoto() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    /// Метод для постановки компазии для трех фото в новости
    func creatLayuotThreePhoto() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.5)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: bottomNestedGroup)
            return section
        }
        return layout
    }
    
    /// Метод для постановки компазии для четырех фото в новости
    func creatLayuotForPhoto() -> UICollectionViewLayout {
        let spacing: CGFloat = 0
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
