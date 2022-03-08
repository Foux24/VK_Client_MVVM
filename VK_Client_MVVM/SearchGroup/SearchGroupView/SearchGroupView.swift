//
//  SearchGroupView.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import UIKit

final class SearchGroupView: UIView {
    
    /// UITableView - Таблица с ячейками
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    /// UISearchBar - Поисковая панель
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.frame = .zero
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.isTranslucent = false
        searchBar.sizeToFit()
        searchBar.backgroundColor = .white
        return searchBar
    }()
    
    /// инициализтор
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstreints()
        self.tapScreen()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Private
private extension SearchGroupView {
    
    /// Добавление и настройка UITableView
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(tableView)
        tableView.tableHeaderView = searchBar
        self.safeAreaLayoutGuide.owningView?.backgroundColor = .white
    }
    
    /// Задаём констрейнты таблицы на UIViewController
    func setupConstreints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    /// Метод тап по экрану убираем клаву
    func tapScreen() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        self.addGestureRecognizer(tapScreen)
    }
    
    /// Убираем клаву с экрана
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
