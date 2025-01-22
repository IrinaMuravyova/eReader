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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
                    }
                    
                    var books: [Book] = []
                    let group = DispatchGroup() // Для ожидания всех асинхронных операций

                    for category in categoriesHtml {
                        // Парсинг данных для списка книг для категории
                        let bookContainers = try category.parent()!.parent()!.select(".book-container") //TODO: обработать опционалы
                        
                        for bookContainer in bookContainers {
                            let id = try bookContainer.attr("data-id") //TODO: уточнить селектор
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
                            
                            var book = Book(
                                id: id,
                                author: author ?? "",
                                title: title,
                                cover: "https://english-e-reader.net" + (cover ?? ""), // TODO: добавить картинку по умолчанию
                                sound: sound.isEmpty ? nil : sound,
                                downloadLink: downloadLink ?? "",
                                language: language,
                                level: level ?? "", // TODO: добавить картинку по умолчанию
                                attributes: [
                                    "category": bookCategory,
                                    "downloaded": "",
                                    "liked": ""
                                ]
                            )
                            
                            if URL(string: downloadLink ?? "") != nil  {
                                
                                group.enter() // Увеличиваем счётчик операций
                                BookLoader.fetchBookStatistics(from: downloadLink!) { downloaded, liked in
 
                                    book.attributes?["downloaded"] = downloaded.formatted()
                                    book.attributes?["liked"] = liked.formatted()

                                    group.leave() // Уменьшаем счётчик операций
                                    books.append(book)
                                }
                            } else {
                                if let category = book.attributes?["category"] {
                                    if category == "Coming Soon" {
                                        books.append(book)
                                    }
                                }
                            }
                        }
                    }
                    // Ожидаем завершения всех операций и Возвращаем данные через completion
                    group.notify(queue: .main) {
                        completion(books)
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
    
    private static func fetchBookStatistics(from downloadLink: String, completion: @escaping (Int, Int) -> Void) {
        
        guard let bookPageUrl = URL(string: "https://english-e-reader.net" + downloadLink) else {
            completion(0, 0)
            return
        }
        
        let request = URLRequest(url: bookPageUrl)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                // Обработка ошибок запроса
                print("Ошибка: \(error.localizedDescription)")
                completion(0, 0) // Возвращаем пустой массив в случае ошибки
                return
            }
            
            // Преобразуем полученные данные в строку
            guard let data = data, let htmlContent = String(data: data, encoding: .utf8) else {
                print("Данные не получены")
                completion(0, 0) // Возвращаем пустой массив, если данных нет
                return
            }
            
            do {
                var numberOfDownloads: Int? = nil
                var numberOfAddToFavorite: Int? = nil
                
                // Парсим HTML с помощью SwiftSoup
                let bookDocument = try SwiftSoup.parse(htmlContent)
                let bookData = try  bookDocument.select("p.text-center")
                if let bookStatistics = bookData.first(where: { element in
                    (try? element.select("a[title=Downloaded]").first()) != nil
                }) {
                    let data = try bookStatistics.text().trimmingCharacters(in: .whitespacesAndNewlines)
                    let dataElements = data.split(separator: " ").map { String($0) }
                    
                    // Записываем найденные числа в переменные
                    if let downloaded = Int(dataElements[0].trimmingCharacters(in: .whitespacesAndNewlines)) {
                        numberOfDownloads = downloaded
                    }
                    if let favorited = Int(dataElements[3].trimmingCharacters(in: .whitespacesAndNewlines)) {
                        numberOfAddToFavorite = favorited
                    }
                }
                completion(numberOfDownloads ?? 0, numberOfAddToFavorite ?? 0)
            } catch {
                print("Ошибка парсинга HTML: \(error.localizedDescription)")
                completion(0, 0)
            }
        }.resume()
    }
}
    
extension String {
    func firstMatch(for regex: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let range = NSRange(startIndex..<endIndex, in: self)
            if let match = regex.firstMatch(in: self, range: range) {
                return String(self[Range(match.range, in: self)!])
            }
        } catch {
            print("Ошибка создания регулярного выражения: \(error)")
        }
        return nil
    }
}

