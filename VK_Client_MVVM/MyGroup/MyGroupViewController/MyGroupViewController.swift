//
//  MyGroupViewController.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//

import UIKit

// MARK: - protocolDelegate
/// определим протокол для передачи обьекта по делегату
protocol AddMyGroupDelegate: AnyObject {
    func getObjectGroup(_ object: Group)
}

// MARK: - MyGroupViewController
final class MyGroupViewController: UIViewController {
    
    /// ModelView
    let viewModel: MyGroupViewModelOutput
    
    /// Инициализтор ModelView
    init(viewModel: MyGroupViewModelOutput) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Вью для отображения
    private var myGroupView: MyGroupView {
        return self.view as! MyGroupView
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        self.view = MyGroupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.viewModel.fileManager = HashPhotoService(container: myGroupView.tableView)
        self.viewModel.loadGroup()
        setupTableView()
        addItemBar()
    }
}

// MARK: - Extension DataSource and Delegate tableView
extension MyGroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Кол-во ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayMyGroup.count
        
    }

    /// Конфигурация данными ячефки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myGroupView.tableView.dequeueReusableCell(forIndexPath: indexPath) as MyGroupTableViewCell
        let image = viewModel.fileManager?.photo(atIndexPath: indexPath, byUrl: viewModel.arrayMyGroup[indexPath.row].photo100)
        cell.configuration(nameGroup: viewModel.arrayMyGroup[indexPath.row].name, iconGroup: image ?? viewModel.defaultImage)
        return cell
    }
    
    /// Анимация для ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object: Group = viewModel.arrayMyGroup[indexPath.row]
            let idGroup = object.id
            viewModel.deletGroup(id: idGroup) { [weak self] in
                guard let self = self else { return }
                self.viewModel.arrayMyGroup.remove(at: indexPath.row)
                self.myGroupView.tableView.reloadData()
                self.viewModel.deleteGroupAlert(VC: self)
            }
        }
    }
    
    /// Нативный метод для изменения содержимого в (кнопке) при анимации удаления строки
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Покинуть"
    }
    
    /// Настроим действия при выделении ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myGroupView.tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: - extension Delegate
extension MyGroupViewController: AddMyGroupDelegate {
    
    /// Метод добавления группы
    func getObjectGroup(_ object: Group) {
        if object.isMember == 0 {
            viewModel.addGroup(id: object.id) { [weak self] in
                guard let self = self else { return }
                self.viewModel.arrayMyGroup.append(object)
                self.myGroupView.tableView.reloadData()
                self.viewModel.addGroupAlert(VC: self, nameGroup: object.name)
            }
        }
    }
}

// MARK: - Private
private extension MyGroupViewController {
    
    /// Настроим TableView
    func setupTableView() {
        myGroupView.tableView.registerCell(MyGroupTableViewCell.self)
        myGroupView.tableView.dataSource = self
        myGroupView.tableView.delegate = self
    }
    
    /// Добавим итем в нави
    func addItemBar() {
        let add = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addGroup))
        add.tintColor = .black
        navigationItem.rightBarButtonItem = add
    }
    
    /// Запускает переход на экран со всеми группами
    @objc func addGroup() {
        let serachGroupViewModel = SearchGroupViewModel()
        let searchGroupController = SearchGroupViewController(viewModel: serachGroupViewModel)
        searchGroupController.delegate = self
        navigationController?.pushViewController(searchGroupController, animated: false)
    }
}
