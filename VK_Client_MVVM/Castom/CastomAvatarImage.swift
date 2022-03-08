//
//  CastomAvatarImage.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 05.03.2022.
//

import UIKit

final class CastomAvatarImage: UIView {

    /// UIImage
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    /// UIImageView
    private(set) lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        return image
    }()
    
    /// View
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 3.0
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()

    /// Обработчка нажатий
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(animate))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        return recognizer
    }()
    
    /// Инициализтор
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImage()
        self.setupContraints()
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        self.setupImage()
        self.setupContraints()
        addGestureRecognizer(tapGestureRecognizer)
    }

    // Анимация сжимания
    @objc func animate() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [],
                       animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 70,
                       options: [],
                       animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}

// MARK: - Private
private extension CastomAvatarImage {
    
    /// Настроим UI
    func setupImage() {
        self.addSubview(containerView)
        containerView.addSubview(imageView)
    }
    
    /// Настройка констрейнтов
    func setupContraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
