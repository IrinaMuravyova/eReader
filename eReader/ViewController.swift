//
//  ViewController.swift
//  eReader
//
//  Created by Irina Muravyeva on 20.12.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let sectors = ["Last updates", "Coming Soon", "Favourited", "Popular"]
    let favoriteSection = 2
    var books = getBooks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
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
        
        let calendar = Calendar.current
        let now = Date()
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let booksForShow: [Book] = switch indexPath.section {
            case 0: books.filter({
                $0.attributes?["dateAdded"] != nil
                && dateFormatter.date(from: $0.attributes!["dateAdded"]!) ?? now  >= oneMonthAgo })
            case 1:
                books.filter({($0.attributes?["comming_soon"] != nil)})
            case 2:
                FavoritesManager.shared.loadFavorites(for: "test")
            case 3:
                books.filter({($0.attributes?["popular"] != nil)})
            default:
                books
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.configure(with: booksForShow)
        
        // Обновление секции таблицы при изменении коллекции
        cell.onSectionUpdate = {
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(integer: 2), with: .automatic) // указан индекс секции с избранным
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}
