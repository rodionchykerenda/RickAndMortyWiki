//
//  CharacterCollectionViewCell.swift
//  RickAndMortyWiki
//
//  Created by Rodion Chikerenda on 19.12.2020.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var statusIndicatorView: UIView!
    @IBOutlet weak var chracterAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleUI()
    }
    // MARK: -  Helpers
    static let identifier = "CharacterCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
    }
    
    func styleUI() {
        chracterAvatar.layer.borderWidth = 1
        chracterAvatar.layer.masksToBounds = false
        chracterAvatar.layer.borderColor = UIColor.white.cgColor
        chracterAvatar.layer.cornerRadius = chracterAvatar.frame.size.width / 2
        chracterAvatar.clipsToBounds = true
        statusIndicatorView.layer.cornerRadius = statusIndicatorView.frame.size.width / 2
        statusIndicatorView.clipsToBounds = true
    }
    
    func update(character: Character) {
        nameLabel.text = character.name
        downloadImage(imageUrl: character.imageUrl)
        setGenderImage(character: character)
        setStatusIndicator(status: character.status)
        setInfoLabel(character: character)
    }
    
    func setGenderImage(character: Character) {
        let origImage: UIImage
        let rightColor: UIColor
        if character.gender == "Male" {
            origImage = #imageLiteral(resourceName: "Mgender")
            rightColor = #colorLiteral(red: 0.1019607843, green: 0.6509803922, blue: 0.7176470588, alpha: 1)
        } else if character.gender == "Female" {
            origImage = #imageLiteral(resourceName: "Wgender-1")
            rightColor = #colorLiteral(red: 0.9607843137, green: 0.4156862745, blue: 0.4745098039, alpha: 1)
            
        } else {
            origImage = #imageLiteral(resourceName: "QuestionMark")
            rightColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        }
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        genderImage.image = tintedImage
        genderImage.tintColor = rightColor
    }
    
    func downloadImage(imageUrl: String) {
        guard let image = URL(string: imageUrl) else {
            fatalError("Cannot convert image url to URL")
        }
        let task = URLSession.shared.dataTask(with: image) { (data, response, error) in
            guard let data = data, error == nil else {return}
            let resultImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.chracterAvatar.image = resultImage
            }
        }.resume()
    }
    
    func setStatusIndicator(status: String) {
        if status == "Alive" {
            statusIndicatorView.backgroundColor = #colorLiteral(red: 0.568627451, green: 0.8196078431, blue: 0.5450980392, alpha: 1)
        } else if status == "Dead" {
            statusIndicatorView.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.1137254902, blue: 0.4549019608, alpha: 1)
        } else {
            statusIndicatorView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.7882352941, blue: 0.5333333333, alpha: 1)
        }
    }
    
    func setInfoLabel(character: Character) {
        infoLabel.text = "\(character.status) - \(character.species)"
    }
    
}
