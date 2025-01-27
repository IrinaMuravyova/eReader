//
//  CollectionViewCell.swift
//  eReader
//
//  Created by Irina Muravyeva on 25.12.2024.
//

import SwiftUI

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var soundImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookAuthorLabel: UILabel!
    @IBOutlet var levelImageView: UIImageView!
    @IBOutlet var downloadedImage: UIImageView!
    @IBOutlet var downloadedLabel: UILabel!
    @IBOutlet var likedImage: UIImageView!
    @IBOutlet var likedLabel: UILabel!
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
        
        coverImageView.loadImage(from: book.cover, placeholder: UIImage(named: "placeholder"))
        coverImageView.contentMode = .scaleAspectFill
        soundImageView.isHidden = book.sound == nil
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.author
        likedImage.tintColor = .gray
        levelImageView.image = switch book.level {
        case .starter :
            UIImage(named: "starter")
        case .elementary :
            UIImage(named: "elementary")
        case .preIntermediate :
            UIImage(named: "pre_intermediate")
        case .intermediate :
            UIImage(named: "intermediate")
        case .intermediatePlus :
            UIImage(named: "intermediate_plus")
        case .upperIntermediate :
            UIImage(named: "upper-intermediate")
        case .advanced :
            UIImage(named: "advanced")
        case .unknown:
            UIImage(named: "unknown")
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
        
        if let category = book.attributes?["category"] {
            if category == "Coming Soon" {
                downloadedImage.isHidden = true
                downloadedLabel.isHidden = true
                likedLabel.isHidden = true
                
                likedImage.contentMode = .scaleAspectFit
                likedImage.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                            // Центрируем изображение по вертикали
                    likedImage.centerYAnchor.constraint(equalTo: statisticsView.centerYAnchor),
                            
                            // Смещаем изображение на 1/4 вправо относительно центра
                    likedImage.centerXAnchor.constraint(equalTo: statisticsView.centerXAnchor, constant:  statisticsView.frame.width / 8 ),
                            
                            // Устанавливаем ширину и высоту изображения
                    likedImage.widthAnchor.constraint(equalToConstant: 15),
                    likedImage.heightAnchor.constraint(equalToConstant: 15)
                ])
            }
        }
    }
    
    @objc private func favoriteImageTappedAction() {
        favoriteImageTapped?()
    }
}
