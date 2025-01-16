//
//  BookLoader.swift
//  eReader
//
//  Created by Irina Muravyeva on 15.01.2025.
//

import Foundation
import SwiftSoup

class BookLoader {
    
    let urlEReader = "https://english-e-reader.net"
    var books: [Book] = []
    
    func fetchBooks() -> [Book] {
        
        guard let url = URL(string: urlEReader) else { return books }
        
        let request = URLRequest(url: url)
        
        // Используем URLSession для отправки запроса
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Обработка ошибок запроса
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                // Обработка полученных данных
//                if let htmlContent = String(data: data, encoding: .utf8) {
//                    DispatchQueue.main.async {
//                        print("Полученные данные: \(htmlContent)")
//                    }
//                }
                
                do {
                    // Преобразуем полученные данные в строку
                    if let htmlContent = String(data: data, encoding: .utf8) {
                        // Парсим HTML с помощью SwiftSoup
                        let document = try SwiftSoup.parse(htmlContent)

                        // Пример парсинга данных для списка книг
                        let bookElements = try document.select(".book-container") // Уточните правильный CSS-селектор
                        print("Найдено элементов: \(bookElements.size())")  // Выводим количество найденных элементов
                        // Маппинг на модели Book
                        var books: [Book] = []

                        for element in bookElements {
                            let id = try element.attr("data-id")
                            let author = try element.select(".cover").text()
                            let title = try element.select("h4").text()
                        
                            let coverSrc = try element.select("img").first()
                            let cover = try coverSrc?.attr("src")
                            
                            let sound = try element.select(".sound-class-name").text() // TODO: Уточните селектор
                            
                            let linkSrc = try element.select("a").first()
                            let downloadLink = try linkSrc?.attr("href")
                            let language = english // TODO: или динамически парсить язык
                            
                            let levelAlt = try element.select("img").last()
                            let level = try levelAlt?.attr("title")

                            let book = Book(
                                id: id,
                                author: author,
                                title: title,
                                cover: cover ?? "", // TODO: добавить картинку по умолчанию
                                sound: sound.isEmpty ? nil : sound,
                                downloadLink: downloadLink ?? "",
                                language: language,
                                level: level ?? "", // TODO: добавить картинку по умолчанию
                                attributes: ["key": "value"]
                            )

                            books.append(book)
                        }
                    }
                } catch {
                    print("Ошибка при парсинге HTML: \(error.localizedDescription)")
                }
            }
            
        }
        task.resume()
        
        
        return books
    }
}
