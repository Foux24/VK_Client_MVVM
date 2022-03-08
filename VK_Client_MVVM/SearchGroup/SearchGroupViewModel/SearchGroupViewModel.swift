//
//  SearchGroupViewModel.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 07.03.2022.
//

import UIKit

protocol SearchGroupViewModelProtocol: AnyObject {
    var service: RequestServerGroup { get set }
}

protocol SearchGroupViewModelOutput: AnyObject {
    var defaultImage: UIImage { get set }
    var fileManager: HashPhotoService? { get set }
    var searchGroup: [Group] { get set }
    func searchGroup(searchText: String, complition: @escaping () -> Void)
}

final class SearchGroupViewModel: SearchGroupViewModelOutput, SearchGroupViewModelProtocol {
    
    /// Массив с искомыми группами
    var searchGroup = [Group]()
    
    /// Default Image
    var defaultImage: UIImage = UIImage(systemName: "photo")!
    
    /// Для кеша изоборажений
    var fileManager: HashPhotoService?
    
    /// Пропертя с экземпляром класса на метод запроса к серверу
    var service = RequestServerGroup()
    
    /// Метод поиска группы
    func searchGroup(searchText: String, complition: @escaping () -> Void) {
        service.searchGroupPromisURL(searchText: searchText)
            .then(on: DispatchQueue.global(), service.searchGroupPromisData(_:))
            .then(service.searchGroupPromiseParsed(_:))
            .done(on: DispatchQueue.main) { response in
                self.searchGroup = response
                complition()
            }.catch { error in
                print(error)
            }
    }
}
