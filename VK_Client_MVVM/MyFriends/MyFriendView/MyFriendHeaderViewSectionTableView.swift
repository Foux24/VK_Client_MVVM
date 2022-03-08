//
//  MyFriendHeaderViewSectionTableView.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 05.03.2022.
//

import UIKit

final class MyFriendHeaderViewSectionTableView: UIView {
    
    /// UILabel - С первой буквой имени
    private(set) lazy var later: UILabel = {
        let leter: UILabel = UILabel()
        leter.textColor = UIColor.black.withAlphaComponent(0.5)
        leter.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        leter.translatesAutoresizingMaskIntoConstraints = false
        return leter
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

private extension MyFriendHeaderViewSectionTableView {
    
    /// Добавление и настройка UITableView
    func setupUI() {
        self.addSubview(later)
        self.backgroundColor = .blue.withAlphaComponent(0.05)
    }
    
    /// Задаём констрейнты таблицы на UIViewController
    func setupConstreints() {
        NSLayoutConstraint.activate([
            later.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            later.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
        ])
    }
}
