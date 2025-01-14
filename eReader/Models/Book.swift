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
    let downloadLink: String
    let language: Language
    let level: String
    let attributes: [String: String]?
}

struct Language: Codable {
    let code: String
    let name: String
    let proficiencyLevels: [String]
}

// MARK: - Language
let english = Language(
    code: "en",
    name: "English",
    proficiencyLevels: ["A1", "A2", "B1", "B2", "C1", "C2", "Native"]
)

let russian = Language(
    code: "ru",
    name: "Русский",
    proficiencyLevels: ["Начальный", "Средний", "Продвинутый", "Свободный"]
)

let chinese = Language(
    code: "ch",
    name: "Chinese",
    proficiencyLevels: ["HSK1", "HSK2", "HSK3", "HSK4", "HSK5", "HSK6"]
)


let languages = [english, russian, chinese]

let localizedProficiencyLevelsByEnglish: [String: [String: String]] = [
    languages[0].code: [
        languages[0].proficiencyLevels[0]: "Beginner",
        languages[0].proficiencyLevels[1]: "Elementary",
        languages[0].proficiencyLevels[2]: "Intermediate",
        languages[0].proficiencyLevels[3]: "Upper Intermediate",
        languages[0].proficiencyLevels[4]: "Advanced",
        languages[0].proficiencyLevels[5]: "Proficient"
    ],
    languages[1].code: [
        languages[1].proficiencyLevels[0]: "Beginner",
        languages[1].proficiencyLevels[1]: "Intermediate",
        languages[1].proficiencyLevels[2]: "Advanced",
        languages[1].proficiencyLevels[3]: "Fluent"
    ],
    languages[2].code: [
        languages[2].proficiencyLevels[0]: "Beginner",
        languages[2].proficiencyLevels[1]: "Elementary",
        languages[2].proficiencyLevels[2]: "Intermediate",
        languages[2].proficiencyLevels[3]: "Upper Intermediate",
        languages[2].proficiencyLevels[4]: "Advanced",
        languages[2].proficiencyLevels[5]: "Proficient"
    ]
]

let localizedProficiencyLevelsByRussian: [String: [String: String]] = [
    languages[0].code: [
        languages[0].proficiencyLevels[0]: "Начальный",
        languages[0].proficiencyLevels[1]: "Начальный",
        languages[0].proficiencyLevels[2]: "Средний",
        languages[0].proficiencyLevels[3]: "Продвинутый",
        languages[0].proficiencyLevels[4]: "Свободный",
        languages[0].proficiencyLevels[5]: "Носитель"
    ],
    languages[1].code: [
        languages[1].proficiencyLevels[0]: "Начальный",
        languages[1].proficiencyLevels[1]: "Средний",
        languages[1].proficiencyLevels[2]: "Продвинутый",
        languages[1].proficiencyLevels[3]: "Свободный"
    ],
    languages[2].code: [
        languages[2].proficiencyLevels[0]: "Начальный",
        languages[2].proficiencyLevels[1]: "Начальный",
        languages[2].proficiencyLevels[2]: "Средний",
        languages[2].proficiencyLevels[3]: "Средний",
        languages[2].proficiencyLevels[4]: "Продвинутый",
        languages[2].proficiencyLevels[5]: "Свободный"
    ]
]

let localizedProficiencyLevelsByChinese: [String: [String: String]] = [
    languages[0].code: [
        languages[0].proficiencyLevels[0]: "初学者",
        languages[0].proficiencyLevels[1]: "初学者",
        languages[0].proficiencyLevels[2]: "中级",
        languages[0].proficiencyLevels[3]: "中级",
        languages[0].proficiencyLevels[4]: "高级",
        languages[0].proficiencyLevels[5]: "流利"
    ],
    languages[1].code: [
        languages[1].proficiencyLevels[0]: "初学者",
        languages[1].proficiencyLevels[1]: "中级",
        languages[1].proficiencyLevels[2]: "高级",
        languages[1].proficiencyLevels[3]: "流利"
    ],
    languages[2].code: [
        languages[2].proficiencyLevels[0]: "初学者",
        languages[2].proficiencyLevels[1]: "初学者",
        languages[2].proficiencyLevels[2]: "中级",
        languages[2].proficiencyLevels[3]: "中级",
        languages[2].proficiencyLevels[4]: "高级",
        languages[2].proficiencyLevels[5]: "流利"
    ]
]

let localizedProficiencyLevelsByLocale: [String: [String: [String: String]]] = [
    "en": localizedProficiencyLevelsByEnglish,
    "ru": localizedProficiencyLevelsByRussian,
    "ch": localizedProficiencyLevelsByChinese
]

// Получение локализации на основе текущей локали
func getLocalizedLevels(for language: Language, locale: String) -> [String] {
    guard let localeTranslations = localizedProficiencyLevelsByLocale[locale],
          let levelTranslations = localeTranslations[language.code] else {
        return language.proficiencyLevels
    }
    return language.proficiencyLevels.map { levelTranslations[$0] ?? $0 }
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
            downloadLink: "https://english-e-reader.net/book/the-new-accelerator-h-g-wells",
            language: english,
            level: "B2",
            attributes: ["downloaded": "303", "liked": "0", "looked": "343", "dateAdded": "12.12.2024", "popular": "true"]),
        Book(
            id: "2",
            author: "Sue Murray",
            title: "The Sky Readers",
            cover: "The_Sky_Readers-Sue_Murray",//https://english-e-reader.net/book/the-sky-readers-sue-murray",
            sound: "https://english-e-reader.net/book/the-sky-readers-sue-murray",
            downloadLink: "https://english-e-reader.net/book/the-sky-readers-sue-murray",
            language: english,
            level: "B1",
            attributes: ["comming_soon": "true"]),
        Book(
            id: "3",
            author: "Leslie Dunkling",
            title: "Six Sketches",
            cover: "Six_Sketches-Leslie_Dunkling",//"https://english-e-reader.net/book/six-sketches-leslie-dunkling",
            sound: nil,
            downloadLink: "https://english-e-reader.net/book/six-sketches-leslie-dunkling",
            language: english,
            level: "A1",
            attributes: nil),
        Book(
            id: "4",
            author: "Nicole Irving",
            title: "Hachiko",
            cover: "book",
            sound: nil,
            downloadLink: "https://english-e-reader.net/book/hachiko-nicole-irving",
            language: english,
            level: "A2",
            attributes: ["popular": "true"]),
        Book(
            id: "5",
            author: "Harris William",
            title: "Dangerous Game",
            cover: "book",
            sound: nil,
            downloadLink: "https://english-e-reader.net/book/dangerous-game-harris-william",
            language: english,
            level: "B1",
            attributes: nil)
    ]
}
