//
//  StorageManager.swift
//  eReader
//
//  Created by Irina Muravyeva on 14.01.2025.
//

import Foundation

final class StorageManager {

    static let shared = StorageManager()
    
    private var defaults = UserDefaults.standard
//    private let profilesKey = "profiles"
//    private let activeProfileKey = "activeProfile"
//    var delegate: StorageManagerDelegate?
    
    private init() {}
    
    func getFavouriteBooks(){
        
    }
//    func fetchProfiles() -> [Profile] {
//        guard let data = defaults.data(forKey: profilesKey) else { return [] }
//        let decoder = JSONDecoder()
//        guard let profiles = try? decoder.decode([Profile].self, from: data) else { return [] }
//        return profiles
//    }
}
