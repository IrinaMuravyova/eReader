//
//  BookTextLoader.swift
//  eReader
//
//  Created by Irina Muravyeva on 27.01.2025.
//

import UIKit
import FolioReaderKit

class BookTextLoader: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Кнопка для открытия книги
        let openBookButton = UIButton(type: .system)
        openBookButton.setTitle("Открыть EPUB книгу", for: .normal)
        openBookButton.addTarget(self, action: #selector(openBook), for: .touchUpInside)
        openBookButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openBookButton)
        
        NSLayoutConstraint.activate([
            openBookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openBookButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func openBook() {
        // URL на EPUB книгу
        guard let bookURL = URL(string: "https://example.com/book.epub") else {
            print("Некорректная ссылка на книгу")
            return
        }
        
        // Скачиваем книгу
        downloadEPUB(from: bookURL) { [weak self] localFilePath in
            guard let self = self, let localFilePath = localFilePath else {
                print("Не удалось загрузить книгу")
                return
            }
            
            // Открываем книгу с помощью FolioReaderKit
            let folioReader = FolioReader()
            let readerConfig = FolioReaderConfig()
            
            folioReader.presentReader(parentViewController: self, withEpubPath: localFilePath.path, andConfig: readerConfig)
        }
    }
    
    func downloadEPUB(from url: URL, completion: @escaping (URL?) -> Void) {
        let session = URLSession.shared
        let task = session.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL, error == nil else {
                print("Ошибка загрузки книги: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion(nil)
                return
            }
            
            // Сохраняем книгу в папке Documents
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
            
            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.moveItem(at: localURL, to: destinationURL)
                print("Книга успешно загружена в: \(destinationURL)")
                completion(destinationURL)
            } catch {
                print("Ошибка сохранения книги: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

