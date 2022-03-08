//
//  SearchGroupViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import UIKit

final class SearchGroupViewController: UIViewController {
    
    /// ViewModel
    let viewModel: SearchGroupViewModelOutput
    
    /// Делегат на добавление группы
    weak var delegate: AddMyGroupDelegate?
    
    /// Инициализтор
    init(viewModel: SearchGroupViewModelOutput) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Вью для отображения
    private var searchGroupView: SearchGroupView {
        return self.view as! SearchGroupView
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        self.view = SearchGroupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fileManager = HashPhotoService(container: searchGroupView.tableView)
        setupView()
    }
}

// MARK: - Extension DataSource and Delegate tableView
extension SearchGroupViewController: UITableViewDelegate, UITableViewDataSource {

    /// Кол-во ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchGroup.count
    }
    
    /// Конфигуратор данными ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchGroupView.tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchGroupTableViewCell
        let image = viewModel.fileManager?.photo(atIndexPath: indexPath, byUrl: viewModel.searchGroup[indexPath.row].photo100)
        cell.configuration(nameGroup: viewModel.searchGroup[indexPath.row].name, iconGroup: image ?? viewModel.defaultImage)
        return cell
    }
    
    /// Выделение ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object: Group = viewModel.searchGroup[indexPath.row]
        self.delegate?.getObjectGroup(object)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension Delegate SearchBar
extension SearchGroupViewController: UISearchBarDelegate {
    
    /// Поиск по тексту
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchGroup = []
        viewModel.searchGroup(searchText: searchText) { [weak self] in
            guard let self = self else { return }
            self.searchGroupView.tableView.reloadData()
        }
    }
}

// MARK: - Private
private extension SearchGroupViewController {
    
    /// Настроим View and TableView and SearcgBar
    func setupView() {
        self.navigationController?.navigationBar.backgroundColor = .white
        searchGroupView.tableView.registerCell(SearchGroupTableViewCell.self)
        searchGroupView.tableView.dataSource = self
        searchGroupView.tableView.delegate = self
        searchGroupView.tableView.keyboardDismissMode = .onDrag
        searchGroupView.searchBar.delegate = self
    }
}
