//
//  Book.swift
//  eReader
//
//  Created by Irina Muravyeva on 23.12.2024.
//

struct Book: Codable {
    let id: String
    let author: String
    let title: String
    var cover: String
    let sound: String?
    let link: String
    let level: Levels
    var attributes: [String: String]?
}

enum Levels: String, Codable {
    case starter = "starter"
    case elementary = "elementary"
    case preIntermediate = "pre-intermediate"
    case intermediate = "intermediate"
    case intermediatePlus = "intermediate-plus"
    case upperIntermediate = "upper-intermediate"
    case advanced = "advanced"
    case unknown = "unknown"
}

// MARK: - MOC data
func getBooks() -> [Book] {
    [
        Book(
            id: "1",
            author: "H. G. Wells",
            title: "The New Accelerator",
            cover: "The_New_Accelerator-H_G_Wells",
            sound: nil,
            link: "https://english-e-reader.net/book/the-new-accelerator-h-g-wells",
            level: .intermediatePlus,
            attributes: ["downloaded": "303", "liked": "0", "looked": "343", "dateAdded": "12.12.2024", "popular": "true"]),
        Book(
            id: "2",
            author: "Sue Murray",
            title: "The Sky Readers",
            cover: "The_Sky_Readers-Sue_Murray",//https://english-e-reader.net/book/the-sky-readers-sue-murray",
            sound: "https://english-e-reader.net/book/the-sky-readers-sue-murray",
            link: "https://english-e-reader.net/book/the-sky-readers-sue-murray",
            level: .intermediate,
            attributes: ["comming_soon": "true"]),
        Book(
            id: "3",
            author: "Leslie Dunkling",
            title: "Six Sketches",
            cover: "Six_Sketches-Leslie_Dunkling",//"https://english-e-reader.net/book/six-sketches-leslie-dunkling",
            sound: nil,
            link: "https://english-e-reader.net/book/six-sketches-leslie-dunkling",
            level: .starter,
            attributes: nil),
        Book(
            id: "4",
            author: "Nicole Irving",
            title: "Hachiko",
            cover: "book",
            sound: nil,
            link: "https://english-e-reader.net/book/hachiko-nicole-irving",
            level: .elementary,
            attributes: ["popular": "true"]),
        Book(
            id: "5",
            author: "Harris William",
            title: "Dangerous Game",
            cover: "book",
            sound: nil,
            link: "https://english-e-reader.net/book/dangerous-game-harris-william",
            level: .intermediate,
            attributes: nil)
    ]
}
