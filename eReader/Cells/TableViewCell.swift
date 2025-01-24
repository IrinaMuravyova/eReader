//
//  TableViewCell.swift
//  eReader
//
//  Created by Irina Muravyeva on 25.12.2024.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: TableViewCell.identifier, bundle: nil)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    let unlikedColor: UIColor = .gray
    let likedColor: UIColor = .red
    let favoriteSection = 2 //TODO: брать с ViewController
    var books = getBooks()
    // Замыкание для обновления секции
    var onSectionUpdate: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with books: [Book]) {
        self.books = books
        collectionView.reloadData()
    }
    
}

// MARK: - CollectionView
extension TableViewCell: UICollectionViewDelegate {
}

extension TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        item.configure(with: books[indexPath.row])
        let favoriteBooks = FavoritesManager.shared.loadFavorites(for: "test")
        item.likedImage.tintColor = favoriteBooks.contains(where: {$0.id == books[indexPath.row].id}) ? likedColor : unlikedColor
        // Обработка клика
        item.favoriteImageTapped = { [weak self] in
            self?.handleImageTap(at: indexPath)
        }
        
        return item
    }
    
    private func handleImageTap(at indexPath: IndexPath) {
        let tappedBook = books[indexPath.row]
        let favoriteBooks = FavoritesManager.shared.loadFavorites(for: "test")
        
        if favoriteBooks.contains(where: {$0.id == books[indexPath.row].id}) {
            FavoritesManager.shared.deleteFavorite(for: "test", book: tappedBook)
        } else {
            FavoritesManager.shared.saveFavorite(for: "test", book: books[indexPath.row])
        }
        
        // Обновляем конкретную ячейку в CollectionView
        collectionView.reloadItems(at: [indexPath])
        // Обновляем секцию TableView
        DispatchQueue.main.async {
            self.onSectionUpdate?()
        }
        print("Image tapped at index: \(indexPath.item)")
    }
    
}

extension TableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 280)
    }
}
