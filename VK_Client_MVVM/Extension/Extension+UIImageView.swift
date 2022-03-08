//
//  Extension+UIImageView.swift
//  VK_Client_MVVM
//
//  Created by Vitalii Sukhoroslov on 04.03.2022.
//
import UIKit

extension UIImageView {
    
    /// Метод загрузки фото в хэш при работе в не таблиц и коллекций
    func loadImage(_ imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        }else{
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data, let response = response else {
                    print("error", error?.localizedDescription ?? "not localizedDescription")
                    return
                }
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
