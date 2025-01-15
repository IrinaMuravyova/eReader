//
//  FavoritesManager.swift
//  eReader
//
//  Created by Irina Muravyeva on 14.01.2025.
//

import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()
    private var defaults = UserDefaults.standard
    
    private init() {}
    
    private func key(for userId: String) -> String {
            return "favoriteBooks_\(userId)"
        }
    
    func saveFavorite(for userId: String, book: Book) {
        var books = loadFavorites(for: userId)
        guard !books.contains(where: { $0.id == book.id }) else { return } // Избегаем дублирования
        books.append(book)
        saveFavorites(for: userId, books: books)
    }
    
    func deleteFavorite(for userId: String, book: Book) {
        var currentFavorites = loadFavorites(for: userId)
        currentFavorites.removeAll { $0.id == book.id }
        saveFavorites(for: userId, books: currentFavorites)
    }
    
    func saveFavorites(for userId: String, books: [Book]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(books) {
            defaults.set(encoded, forKey: key(for: userId))
        }
    }
    
    func loadFavorites(for userId: String) -> [Book] {
        guard let data = defaults.data(forKey: key(for: userId)) else {
            return []
        }

        let decoder = JSONDecoder()
        return (try? decoder.decode([Book].self, from: data)) ?? []
    }

}
