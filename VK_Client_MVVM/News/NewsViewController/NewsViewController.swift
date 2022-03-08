//
//  NewsViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

/// Протокол Делегат для обновления высоты ячейки текста
protocol ShowMoreDelegate: AnyObject {
    func updateTextHeight(indexPath: IndexPath)
}

final class NewsViewController: UIViewController {
    
    /// ViewModel
    private let viewModel: NewsViewModelOutput
    
    /// Инициализтор
    init(viewModel: NewsViewModelOutput) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View
    private var newsView: NewsView {
        return self.view as! NewsView
    }
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        self.view = NewsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshcontrol()
        newsView.tableView.prefetchDataSource = self
        self.viewModel.fileManager = HashPhotoService(container: newsView.tableView)
        self.viewModel.loadNews()
        setupView()
    }
}

// MARK: - extension NewsViewController
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// кол-во секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.news.count
    }
    
    /// кол-во строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    /// Конфигуратор данными ячефки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = viewModel.news[indexPath.section]
        let authorNews = viewModel.getOwnerNews(news: news)
        
        /// Определим где какая ячейка должна отобразиться в зависимости от индекса
        switch indexPath.row {
            /// CellAuthorNews
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NewsHeaderTableViewCell
            let image = viewModel.fileManager?.photo(atIndexPath: indexPath, byUrl: authorNews.avatarURL)
            cell.configuration(nameAvtor: authorNews.name, dateNews: viewModel.formateDate(date: news.date), avatarAvtor: image ?? viewModel.defaultImage)
            return cell
            
            /// CellTextNews
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NewsTextTableViewCell
            cell.configuration(text: news.text ?? "")
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
            
            /// CellImages
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NewsCollectionImageTableViewCell
            cell.configuration(collectionPhoto: viewModel.collectionPhotoTableView(newsResponse: news))
            return cell
            
            /// CellLikesreposts
        case 3:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NewsFooterTableViewCell
            cell.configurationCell(countLike: news.likes?.count ?? 0,
                                   countRepost: news.reposts?.count ?? 0,
                                   countView: news.views?.count ?? 0,
                                   controlLike: news.likes?.canLike ?? 0,
                                   sourseID: authorNews.id,
                                   postID: news.postID)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    /// Для определения разграничения новостей между собой определим Header
    /// Нативный методом определим его высоту
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    /// Нативным методом определим цвет Header-а
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }
    
    /// Автоподстчет высоты ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            if viewModel.news[indexPath.section].text == "" {
                return tableView.bounds.width * CGFloat(0)
            }
        }
        
        if indexPath.row == 2 {
            if viewModel.height != 0 || viewModel.width != 0 {
                let aspectRatio = Double(viewModel.height) / Double(viewModel.width)
                return tableView.bounds.width * CGFloat(aspectRatio)
            }
        }
        return UITableView.automaticDimension
    }
}

// MARK: - Private
private extension NewsViewController {
    
    /// Настройки TableView
    func setupView() {
        newsView.tableView.registerCell(NewsHeaderTableViewCell.self)
        newsView.tableView.registerCell(NewsTextTableViewCell.self)
        newsView.tableView.registerCell(NewsCollectionImageTableViewCell.self)
        newsView.tableView.registerCell(NewsFooterTableViewCell.self)
        newsView.tableView.dataSource = self
        newsView.tableView.delegate = self
    }
}

/// Расширим класс на добавление новых новостей и появлении более старых новостей
// MARK: - Extension controller at DataSourcePrefetching
extension NewsViewController: UITableViewDataSourcePrefetching {
    
    /// Метод для добавления новых новостей
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.loadNewNews(indexPaths: indexPaths, tableView: newsView.tableView)
    }
    
    /// Определим действия нативному елементу как ( елемент вращающаеся загрузка)
    fileprivate func setupRefreshcontrol() {
        newsView.tableView.refreshControl = UIRefreshControl()
        newsView.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Поиск новых новостей")
        newsView.tableView.refreshControl?.tintColor = .black
        newsView.tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    /// Определим что нужно выполнить действию
    @objc func refreshNews() {
        viewModel.reloadNews(tableView: newsView.tableView)
    }
}

// MARK: - ShowMoreDelegate
extension NewsViewController: ShowMoreDelegate {
    
    func updateTextHeight(indexPath: IndexPath) {
        newsView.tableView.beginUpdates()
        newsView.tableView.endUpdates()
        newsView.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
