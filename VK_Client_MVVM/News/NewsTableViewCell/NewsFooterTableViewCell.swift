//
//  NewsFooterTableViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import UIKit
// MARK: - NewsTableViewCell - for
/// Опредлим класс с четвертой  по счету ячейки в нашей таблице
class NewsFooterTableViewCell: UITableViewCell {
    
    /// Property
    static let reuseID = String(describing: NewsFooterTableViewCell.self)
    
    /// UIElements
    private let likeView: UIView = {
        let view = UIView(frame: CGRect(x: 5, y: 5, width: 82, height: 30))
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    /// Кнопка поставки лайка
    private let likeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 5, y: 5, width: 22, height: 18))
        let image = UIImage(systemName: "heart.slash")
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.backgroundColor = .clear
        return button
    }()
    
    /// Отмена лайка
    private let cancelLikeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 5, y: 5, width: 22, height: 18))
        let image = UIImage(systemName: "heart.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.backgroundColor = .clear
        return button
    }()
    
    /// Кол-во лайков
    private let countLike: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    /// Кол-во просмотров
    private let repostView: UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 5, width: 82, height: 30))
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    /// Иконка репоста
    private let repostImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "arrowshape.turn.up.right")
        imageView.frame = CGRect(x: 5, y: 5, width: 22, height: 18)
        imageView.image = image
        imageView.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    /// Кол-во репостов
    private let countRepost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    /// View
    private let view: UIView = {
        let view = UIView(frame: CGRect(x: 300, y: 5, width: 110, height: 30))
        return view
    }()
    
    /// Image просмотров
    private let viewImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "eyes")
        imageView.frame = CGRect(x: 5, y: 5, width: 22, height: 18)
        imageView.image = image
        imageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.backgroundColor = .white
        return imageView
    }()
    
    /// Кол-во просмотров
    private let countView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .white
        return label
    }()
    
    /// Property Like
    var like = 0
    var controlLike = 0
    var sourceID = 0
    var postID = 0
    var myLike = 0
    
    /// Экземпляр класса для запроса лайка
    var service = RequestServerNews()
    
    /// Конфигурация ячейки
    func configurationCell(countLike like: Int,
                           countRepost repost: Int,
                           countView view: Int,
                           controlLike control: Int,
                           sourseID sourse: Int,
                           postID post: Int) {
        
        countLike.text = String(like)
        countRepost.text = String(repost)
        countView.text = String(view)
        controlLike = control
        sourceID = sourse
        postID = post
        setupTableCell()
        setupConstreints()
    }
}

// MARK: - private CellLikesReposts
private extension NewsFooterTableViewCell {
    
    /// Add UIElements in ContentView
    func setupTableCell() {
        contentView.backgroundColor = .white
        contentView.addSubview(likeView)
        contentView.addSubview(repostView)
        contentView.addSubview(view)
        likeView.addSubview(countLike)
        repostView.addSubview(repostImage)
        repostView.addSubview(countRepost)
        view.addSubview(viewImage)
        view.addSubview(countView)
        addButton()
        setupActionButton()
    }
    
    /// Добавим действия нашим кнопкам
    func setupActionButton() {
        likeButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        cancelLikeButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    /// Установка констрейнтов
    func setupConstreints() {
        NSLayoutConstraint.activate([
            countLike.widthAnchor.constraint(equalToConstant: 60),
            countLike.heightAnchor.constraint(equalToConstant: 12),
            countLike.topAnchor.constraint(equalTo: likeView.topAnchor, constant: 8),
            countLike.leadingAnchor.constraint(equalTo: likeView.leadingAnchor, constant: 30),
            
            countRepost.widthAnchor.constraint(equalToConstant: 60),
            countRepost.heightAnchor.constraint(equalToConstant: 12),
            countRepost.topAnchor.constraint(equalTo: repostView.topAnchor, constant: 8),
            countRepost.leadingAnchor.constraint(equalTo: repostView.leadingAnchor, constant: 30),
            
            countView.widthAnchor.constraint(equalToConstant: 80),
            countView.heightAnchor.constraint(equalToConstant: 12),
            countView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            countView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            
        ])
    }
    
    /// Метод для Добавления или Удаления лайка
    @objc func onClick() {
        if controlLike == 0 || myLike == 0{
            controlLike += 1
            if myLike == 0 {
                myLike += 1
            }
            service.addLikeNewsPost(ownerID: sourceID, postID: postID) { [self] result in
                switch result {
                case .success(let count):
                    countLike.text = String(count.likes)
                    UIView.transition(from: likeButton,
                                      to: cancelLikeButton,
                                      duration: 0.2,
                                      options: .transitionCrossDissolve)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            if myLike == 1 || controlLike == 1 {
                controlLike -= 1
                if myLike == 1 {
                    myLike -= 1
                }
                service.removeLikeNewsPost(ownerID: sourceID, postID: postID) { [self] result in
                    switch result {
                    case .success(let count):
                        countLike.text = String(count.likes)
                        UIView.transition(from: cancelLikeButton,
                                          to: likeButton,
                                          duration: 0.2,
                                          options: .transitionCrossDissolve)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    /// Метод добавления кнопки по условию
    func addButton() {
        if controlLike == 0 {
            likeView.addSubview(likeButton)
        }else if controlLike == 1{
            myLike += 1
            likeView.addSubview(cancelLikeButton)
        }
    }
}
