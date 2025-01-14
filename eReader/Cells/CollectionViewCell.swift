//
//  CollectionViewCell.swift
//  eReader
//
//  Created by Irina Muravyeva on 25.12.2024.
//

import SwiftUI

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var soundImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookAuthorLabel: UILabel!
    @IBOutlet var levelImageView: UIImageView!
    @IBOutlet var downloadedLabel: UILabel!
    @IBOutlet var likedImage: UIImageView!
    @IBOutlet var likedLabel: UILabel!
    @IBOutlet var lookedLabel: UILabel!
    @IBOutlet var statisticsView: UIView!
    
    static let identifier  = "CollectionViewCell"
    var favoriteImageTapped: (() -> Void)? // Замыкание для обработки клика
    
    static func nib() -> UINib {
        UINib(nibName: CollectionViewCell.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        soundImageView.layer.cornerRadius = soundImageView.frame.width / 2
        levelImageView.layer.borderColor = UIColor(.black).cgColor
        levelImageView.layer.borderWidth = 1
        
        // Добавляем распознаватель жестов
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteImageTappedAction))
        likedImage.addGestureRecognizer(tapGesture)
    }
    
    func configure(with book: Book) {
        coverImageView.image = UIImage(named: book.cover)
        coverImageView.contentMode = .scaleAspectFill
        soundImageView.isHidden = book.sound == nil
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.author
        likedImage.tintColor = .gray
        levelImageView.image = switch book.level {
        case english.proficiencyLevels[0] :
            UIImage(named: "a1_starter")
        case english.proficiencyLevels[1] :
            UIImage(named: "a2_elementary")
        case english.proficiencyLevels[2] :
            UIImage(named: "b1_pre_intermediate")
        case english.proficiencyLevels[3] :
            UIImage(named: "b2_intermediate")
        case english.proficiencyLevels[4] :
            UIImage(named: "c1_intermediate_plus")
        case english.proficiencyLevels[5] :
            UIImage(named: "c2_advanced")
        default:
            UIImage(named: "native")
        }
        
        if let downloadedCount = book.attributes?["downloaded"] {
            downloadedLabel.text = downloadedCount
        } else {
            downloadedLabel.text = ""
        }
        
        if let likedCount = book.attributes?["liked"] {
            likedLabel.text = likedCount
        } else {
            likedLabel.text = ""
        }
        
        if let lookedCount = book.attributes?["looked"] {
            lookedLabel.text = lookedCount
        } else {
            lookedLabel.text = ""
        }
        
    }
    
    @objc private func favoriteImageTappedAction() {
        favoriteImageTapped?()
    }

}
