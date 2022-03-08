//
//  MyGroupViewModel.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import UIKit

protocol MyGroupViewModelProtocol: AnyObject {
    var service: RequestServerGroup { get set }
}

protocol MyGroupViewModelInput: AnyObject {

}

protocol MyGroupViewModelOutput: AnyObject {
    var defaultImage: UIImage { get set }
    var fileManager: HashPhotoService? { get set }
    var arrayMyGroup: [Group] { get set }
    func loadGroup() -> Void
    func deletGroup(id: Int, complition: @escaping () -> Void)
    func addGroup(id: Int, complition: @escaping () -> Void)
    func deleteGroupAlert(VC: UIViewController) -> Void
    func addGroupAlert(VC: UIViewController,nameGroup name: String) -> Void
}

final class MyGroupViewModel: MyGroupViewModelOutput, MyGroupViewModelProtocol {
    
    /// Массив с группами пользователя
    var arrayMyGroup = [Group]()
    
    /// Для кеша изоборажений
    var fileManager: HashPhotoService?
    
    /// Default Image
    var defaultImage: UIImage = UIImage(systemName: "photo")!
    
    /// Пропертя с экземпляром класса на метод запроса к серверу
    var service = RequestServerGroup()

    /// Метод загрузки списка груп
    func loadGroup() -> Void {
        service.loadGroupPromisURL()
            .then(on: DispatchQueue.global(), service.loadGroupPromisData(_:))
            .then(service.loadGroupPromiseParsed(_:))
            .done(on: DispatchQueue.main) { response in
                self.arrayMyGroup = response
            }.catch { error in
                print(error)
            }
    }
    
    /// Метод удаления группы
    func deletGroup(id: Int, complition: @escaping () -> Void) {
        service.deleteGroupPromisURL(id: id)
            .then(on: DispatchQueue.global(), service.deleteGroupPromisData(_:))
            .then(service.deleteGroupPromiseParsed(_:))
            .done(on: DispatchQueue.main ) { response in
                if response.response == 1 {
                    complition()
                }
            }.catch { error in
                print(error)
            }
    }
    
    /// Метод удаления группы
    func addGroup(id: Int, complition: @escaping () -> Void) {
        service.addGroupPromisURL(id: id)
            .then(on: DispatchQueue.global(), service.addGroupPromisData(_:))
            .then(service.addGroupPromiseParsed(_:))
            .done(on: DispatchQueue.main ) { response in
                if response.response == 1 {
                    complition()
                }
            }.catch { error in
                print(error)
            }
    }
}

// MARK: - Extension Alert
extension MyGroupViewModel {
    
    /// Алерт при удалении группы
    func deleteGroupAlert(VC: UIViewController) -> Void {
        let alert = UIAlertController(title: "Warning", message: "Вы покинули группу", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
    }
    
    /// Алерт при Добавлении группы
    func addGroupAlert(VC: UIViewController,nameGroup name: String) -> Void {
        let alert = UIAlertController(title: "Warning", message: "Вы вступили в группу ( \(name) )", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
    }
    
}

