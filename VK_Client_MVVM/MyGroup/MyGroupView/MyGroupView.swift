//
//  MyGroupView.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import UIKit

final class MyGroupView: UIView {
    
    /// UITableView - Таблица с ячейками
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
}

// MARK: - Private
private extension MyGroupView {
    
    /// Добавление и настройка UITableView
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(tableView)
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
}
