//
//  MyFriendsViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

// MARK: - MyFriendsViewController
final class MyFriendsViewController: UIViewController {
    
    /// ViewModel
    private let viewModel: MyFriendViewModelOutput
    
    init(viewModel: MyFriendViewModelOutput) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Вью для отображения
    private var myFriendView: MyFriendView {
        return self.view as! MyFriendView
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        self.view = MyFriendView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.viewModel.fileManager = HashPhotoService(container: myFriendView.tableView)
        viewModel.getSortedFriend() { [weak self] in
            guard let self = self else { return }
            self.myFriendView.tableView.reloadData()
        }
        setupView()
    }
    
}

extension MyFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Кол-во секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrayFilteredFriendData.count
    }
    
    /// Кол-во ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayFilteredFriendData[section].data.count
        
    }
    /// Настроим Тайтл Хеадера
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = viewModel.arrayFriend[section]
        return String(section.key)
    }
    
    /// Конфигурация данными ячефки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myFriendView.tableView.dequeueReusableCell(forIndexPath: indexPath) as MyFriendTableViewCell
        let friendData = viewModel.arrayFilteredFriendData[indexPath.section].data
        let friend = friendData[indexPath.row]
        let image = viewModel.fileManager?.photo(atIndexPath: indexPath, byUrl: friend.photo200_Orig)
        cell.configuration(name: "\(friend.firstName) \(friend.lastName)", avatar: image ?? viewModel.defaultImage)
        return cell
    }
    
    /// Определим колонку с правой стороны и ее содержимое
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.arrayLettersOfNames
    }
    
    /// Настроим хеадр секции
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MyFriendHeaderViewSectionTableView()
        headerView.later.text = String(viewModel.arrayFilteredFriendData[section].key)
        return headerView
    }
    
    /// Настроим действия при выделении ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = viewModel.arrayFilteredFriendData[indexPath.section].data[indexPath.row]
        let viewModelCardMyFriend = CardMyFriendViewModel()
        let cardMyFriendVC = CardMyFriendViewController(friend: friend, viewModel: viewModelCardMyFriend)
        self.myFriendView.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(cardMyFriendVC, animated: true)
    }
}

// MARK: - SearchBarDelegate
extension MyFriendsViewController: UISearchBarDelegate, MyFriendViewModelInput {

    /// Настроим логику SearchBar-а
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            serachBarFiltered(searchText: searchText)
            self.myFriendView.tableView.reloadData()
        }
        
        func serachBarFiltered(searchText: String) {
            viewModel.serachBarFiltered(searchText: searchText)
        }
    }

private extension MyFriendsViewController {
    
    /// Добавление и настройка UITableView
    func setupView() {
        view.backgroundColor = .clear
        myFriendView.tableView.registerCell(MyFriendTableViewCell.self)
        myFriendView.tableView.dataSource = self
        myFriendView.tableView.delegate = self
        myFriendView.tableView.keyboardDismissMode = .onDrag
        myFriendView.searchBar.delegate = self
    }
}
