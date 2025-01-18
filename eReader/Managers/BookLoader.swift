//
//  BookLoader.swift
//  eReader
//
//  Created by Irina Muravyeva on 15.01.2025.
//

import SwiftSoup
import UIKit

class BookLoader {
    
    let urlEReader = "https://english-e-reader.net"
    var books: [Book] = []
    
    func fetchBooks(completion: @escaping ([Book]) -> Void) {
        
        guard let url = URL(string: urlEReader) else {
            completion([]) // Если URL некорректен, сразу возвращаем пустой массив
            return
        }
        
        let request = URLRequest(url: url)
        
        // Используем URLSession для отправки запроса
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                // Обработка ошибок запроса
                print("Ошибка: \(error.localizedDescription)")
                completion([]) // Возвращаем пустой массив в случае ошибки
                return
            }
            
            guard let data = data else {
                print("Данные не получены")
                completion([]) // Возвращаем пустой массив, если данных нет
                return
            }
                do {
                    // Преобразуем полученные данные в строку
                    if let htmlContent = String(data: data, encoding: .utf8) {
                        // Парсим HTML с помощью SwiftSoup
                        let document = try SwiftSoup.parse(htmlContent)
                        
                        let categoriesGroup = try document.select(".category")
                        let categoriesHtml = try categoriesGroup.select(".col-md-10")
                        var categories : [String] = []
                        
                        for category in categoriesHtml {
                            categories.append(try category.text())
//                            print("Category HTML: \(try category.html())")
                        }
                        print(categories)

                        // Всего найдено книг на странице
//                        print("Найдено элементов categoriesGroup: \(try categoriesGroup.select(".book-container").size())")
                        
                        
                        var books: [Book] = []
                        for category in categoriesHtml {
                            // Парсинг данных для списка книг для категории
                            let bookContainers = try category.parent()!.parent()!.select(".book-container") //TODO: обработать опционалы
//                            print("Number of book containers: \(bookContainers.count)")

                            for bookContainer in bookContainers {
                                let id = try bookContainer.attr("data-id")
                                let author = try bookContainer.parent()?.select("p.cover").text()
                                let title = try bookContainer.select("h4").text()
                            
                                let coverSrc = try bookContainer.select("img").first()
                                let cover = try coverSrc?.attr("src")
                                
                                let sound = try bookContainer.select(".sound-class-name").text() // TODO: Уточнить селектор
                                
                                let linkSrc = try bookContainer.select("a").first()
                                let downloadLink = try linkSrc?.attr("href")
                                
                                let language = english // TODO: или динамически парсить язык
                                
                                let levelAlt = try bookContainer.select("img").last()
                                let level = try levelAlt?.attr("title")
                                
                                let bookCategory = try category.text()
                                
                                let book = Book(
                                    id: id,
                                    author: author ?? "",
                                    title: title,
                                    cover: "https://english-e-reader.net" + (cover ?? ""), // TODO: добавить картинку по умолчанию
                                    sound: sound.isEmpty ? nil : sound,
                                    downloadLink: downloadLink ?? "",
                                    language: language,
                                    level: level ?? "", // TODO: добавить картинку по умолчанию
                                    attributes: [
                                        "category": bookCategory
                                                
                                    ]
                                )
//                                print("book ", book.title, "category", book.attributes?["category"] ?? "")

                                books.append(book)
                                // Возвращаем данные через completion
                                completion(books)
                        }
                        
                        }
                        
                        
                    }
                } catch {
                    print("Ошибка при парсинге HTML: \(error.localizedDescription)")
                    completion([]) // Возвращаем пустой массив в случае ошибки
                }
            }
        task.resume()
    }
    
    // Загрузка изображения
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
