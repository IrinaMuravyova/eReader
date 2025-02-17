//
//  ImageCache.swift
//  eReader
//
//  Created by Irina Muravyeva on 16.01.2025.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>() // Общий кэш для приложения
}

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        //TODO: Устанавливаем изображение-заглушку - добавить
        self.image = placeholder
        
        guard let url = URL(string: urlString) else {
            print("Некорректный URL: \(urlString)")
            return
        }
        
        let cacheKey = NSString(string: urlString) // Ключ для кэша
        
        // Проверяем, есть ли изображение в кэше
        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // Загружаем изображение из сети
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Не удалось преобразовать данные в UIImage")
                return
            }
            
            // Сохраняем изображение в кэш
            ImageCache.shared.setObject(image, forKey: cacheKey)
            
            // Обновляем UIImageView на главном потоке
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
