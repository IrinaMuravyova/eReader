//
//  ViewController.swift
//  eReader
//
//  Created by Irina Muravyeva on 20.12.2024.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let sectors = ["Last updates", "Coming Soon", "Favorited", "Popular"]
    private let favoriteSection = 2
    private var books: [Book] = [] //getBooks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        let bookLoader = BooksLoader()
        bookLoader.fetchBooks{ [weak self] loadedBooks in
            guard let self = self else { return }
            
            DispatchQueue.main.async{
                if loadedBooks.isEmpty {
                       print("Массив книг пуст.")
                   } else {
                       // Обновляем массив и перезагружаем таблицу
                       self.books = loadedBooks
                       self.tableView.reloadData()
//                       print("Загруженные книги: \(loadedBooks)")
                   }
           }
        }
    }
}

// MARK: - TableView
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: sectors[0]
        case 1: sectors[1]
        case 2: sectors[2]
        case 3: sectors[3]
        default:
            ""
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let booksForShow: [Book] = switch indexPath.section {
            case 0: 
                books.filter({$0.attributes?["category"] == "Last updates"})
            case 1:
                books.filter({($0.attributes?["category"] == "Coming Soon")})
            case 2:
                FavoritesManager.shared.loadFavorites(for: "test")
            case 3:
                books.filter({($0.attributes?["category"] == "Popular at online reader")})
            default:
                books
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.configure(with: booksForShow)
        
        // Обновление секции таблицы при изменении коллекции
        cell.onSectionUpdate = {
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(integer: 2), with: .automatic) // индекс секции с избранным
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}
