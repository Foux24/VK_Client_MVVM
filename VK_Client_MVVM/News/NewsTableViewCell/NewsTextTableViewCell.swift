//
//  NewsTextTableViewCell.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 08.03.2022.
//

import UIKit

// MARK: - CellTextNews
class NewsTextTableViewCell: UITableViewCell {

    static let reuseID = String(describing: NewsTextTableViewCell.self)
    
    /// UILabel Text News
    let textNews: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        return label
    }()
    
    /// Кнопка показать текст полностью
    let showMore: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show More..", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .clear
        button.layer.borderWidth = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    /// Расстояние отступа от bounds для определения высота текста ( Не используется ) оставлено в качетстве примера на будущее
    private let instets: CGFloat = 10.0
    
    /// Флаг метка для показа полного текста
    private var shortTextState: Bool = false
    
    /// Делегат для обновления высоты ячейки текста
    var delegate: ShowMoreDelegate?
    
    /// IndexPath ячейки в таблице
    var indexPath: IndexPath = IndexPath()
    
    /// Метод для конфигурации текста новости
    func configuration(text: String) {
        setupTextNewsCell()
        setupConstreints()
        setTextNews(text: text)
        selectionStyle = .none
    }
}

// MARK: - Private extension CellTextNews
private extension NewsTextTableViewCell {
    /// Add UIElements in CollectionViewCell
    func setupTextNewsCell() {
        contentView.backgroundColor = .white
        contentView.addSubview(textNews)
        showMore.addTarget(self, action: #selector(addNumberOfLines), for: .touchUpInside)
    }
    
    /// Setup Constreints UIElement
    func setupConstreints() {
        let bottomAnchor = textNews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        bottomAnchor.priority = .init(rawValue: 1000)
        
        NSLayoutConstraint.activate([
            textNews.topAnchor.constraint(equalTo: contentView.topAnchor),
            textNews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            textNews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            bottomAnchor,
        ])
    }
    
    /// Добавление кнопки показать текст
    func setupConstraintButtonShowMore() {
        contentView.addSubview(showMore)
        NSLayoutConstraint.activate([
            showMore.topAnchor.constraint(equalTo: textNews.bottomAnchor, constant: 10),
            showMore.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            showMore.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            showMore.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
}

// MARK: - extension
extension NewsTextTableViewCell {
    
    /// Метод расчета высоты и ширины текста в UILabel
    func getLabelTextNewsSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - instets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    /// Метод для передачи текста в лейбл и его настройка размеров
    func setTextNews(text: String) {
        textNews.text = text
        let sizeTextNews = getLabelTextNewsSize(text: text, font: .systemFont(ofSize: 14))
        switch sizeTextNews.height {
        case 200...:
            showShortText()
            setupConstraintButtonShowMore()
            return
        case 0..<200:
            showFullText()
        default:
            return
        }
    }
    
    /// Переключает режим отображения текста поста
    @objc func addNumberOfLines() {
        if shortTextState == true {
            showFullText()
            showMore.isHidden = true
        } else {
            showShortText()
            showMore.setTitle("Show more", for: .normal)
        }
        delegate?.updateTextHeight(indexPath: indexPath)
    }
    
    /// Отображает весь текст поста
    func showFullText() {
        textNews.numberOfLines = 0
        shortTextState = false
    }
    
    /// Отображает укороченный текст поста
    func showShortText() {
        textNews.numberOfLines = 4
        shortTextState = true
    }
}
