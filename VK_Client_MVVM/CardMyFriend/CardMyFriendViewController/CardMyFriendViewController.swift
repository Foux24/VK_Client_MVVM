//
//  CardMyFriendViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 06.03.2022.
//

import UIKit

final class CardMyFriendViewController: UIViewController {
    
    private let friend: Friends
    
    private let viewModel: CardMyFriendViewModelOutput
    
    init(friend: Friends, viewModel: CardMyFriendViewModelOutput) {
        self.friend = friend
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Для кеша изоборажений
    var fileManager: HashPhotoService?
    
    /// Вью для отображения
    private var cardMyFriendView: CardMyFriendView {
        return self.view as! CardMyFriendView
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        self.view = CardMyFriendView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileManager = HashPhotoService(container: cardMyFriendView.collectionView)
        viewModel.fetchPhotos(idFriend: friend.id) { [weak self] in
            guard let self = self else { return }
            self.cardMyFriendView.collectionView.reloadData()
            self.cardMyFriendView.countPhotoLabel.text = "\(self.viewModel.arrayURLSizeZ.count)"
        }
        setupDataUI()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - UITableViewDataSource
extension CardMyFriendViewController: UICollectionViewDataSource {
    
    /// Определим кол-во секйци
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.defaultCountSection
    }
    
    /// Кол-во итемов в секции коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrayURLSizeZ.count
    }
    
    /// Данные для итема
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardMyFriendView.collectionView.dequeueReusableCell(forIndexPath: indexPath) as CardMyFriendCollectionViewCell
        let image = fileManager?.photo(atIndexPath: indexPath, byUrl: viewModel.arrayURLSizeZ[indexPath.row])
        cell.configureImage(with: image)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CardMyFriendViewController: UICollectionViewDelegate {
    
    /// Действие при выделении итема
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let allPhotoVC = AllPhotoFriendViewcontroller(arrayURLSizeZ: viewModel.arrayURLSizeZ, selectedPhotoFriend: indexPath)
            self.cardMyFriendView.collectionView.deselectItem(at: indexPath, animated: true)
            self.navigationController?.pushViewController(allPhotoVC, animated: true)
    }
}

private extension CardMyFriendViewController {
    
    /// Установим данные для UI
    func setupDataUI() {
        self.title = friend.domain
        cardMyFriendView.configurationUI(image: friend.photo200_Orig,
                                         name: "\(friend.firstName) \(friend.lastName)",
                                         status: "\(friend.status ?? "")",
                                         time: self.viewModel.formateDate(date: friend.lastSeen?.time ?? 0))
    }
    
    /// назначим серч бару и коллекции делага и дата соурс
    func setupView() {
        view.backgroundColor = .white
        self.cardMyFriendView.collectionView.registerCell(CardMyFriendCollectionViewCell.self)
        self.cardMyFriendView.collectionView.delegate = self
        self.cardMyFriendView.collectionView.dataSource = self
        self.navigationItem.backButtonTitle = ""
    }
}
