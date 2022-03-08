//
//  AllPhotoFriendViewcontroller.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 06.03.2022.
//

import UIKit

// MARK: - classFullScreenController
class AllPhotoFriendViewcontroller: UIViewController {
    
    /// Массив с УРЛ
    var arrayURLSizeZ: [String]
    
    /// Индекс фото
    var selectedPhotoFriend: IndexPath
    
    /// Для кеша изоборажений
    var fileManager: HashPhotoService?
    
    init(arrayURLSizeZ: [String], selectedPhotoFriend: IndexPath) {
        self.arrayURLSizeZ = arrayURLSizeZ
        self.selectedPhotoFriend = selectedPhotoFriend
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Вью для отображения
    private var allPhotoFriendView: AllPhotoFriendView {
        return self.view as! AllPhotoFriendView
    }
    
    // MARK: - lifeCycle
    override func loadView() {
        super.loadView()
        self.view = AllPhotoFriendView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileManager = HashPhotoService(container: allPhotoFriendView.collectionView)
        setupCollectionView()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        allPhotoFriendView.collectionView.scrollToItem(at: selectedPhotoFriend, at: .centeredVertically, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension AllPhotoFriendViewcontroller: UICollectionViewDataSource {
    
    /// Определим кол-во секйци
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    /// Кол-во итемов в секции коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayURLSizeZ.count
    }
    
    /// Данные для итема
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = allPhotoFriendView.collectionView.dequeueReusableCell(forIndexPath: indexPath) as AllPhotoFriendCollectionViewCell
        let image = fileManager?.photo(atIndexPath: indexPath, byUrl: arrayURLSizeZ[indexPath.row])
        cell.configureImage(with: image)
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension AllPhotoFriendViewcontroller: UICollectionViewDelegate {
    
    /// Действие при выделении итема
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.allPhotoFriendView.collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Добавим в классу анимаци и методы подгрузки фото
private extension AllPhotoFriendViewcontroller {
    
    /// Настроим CollectionView
    func setupCollectionView() {
        view.backgroundColor = .black
        self.allPhotoFriendView.collectionView.registerCell(AllPhotoFriendCollectionViewCell.self)
        self.allPhotoFriendView.collectionView.delegate = self
        self.allPhotoFriendView.collectionView.dataSource = self
        self.allPhotoFriendView.collectionView.isScrollEnabled = false
    }
    
    /// Настроим контроллер
    func setupView() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .black
    }
}
