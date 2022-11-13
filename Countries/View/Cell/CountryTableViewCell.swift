//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Buse Topuz on 10.11.2022.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    var countryID: String?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with country: Country) {
        DispatchQueue.main.async {
            self.countryNameLabel.text = country.name
            if CoreDataManager.isFavoritedCountryExists(countryID: self.countryID ?? "") {
                self.favoriteButton.setImage(UIImage(systemName: "heart.fill"),for: .normal)
            } else {
                self.favoriteButton.setImage(UIImage(systemName: "heart"),for: .normal)
            }
        }
    }
    
    func setup(model: Country) {
        countryNameLabel.text = model.name
        if CoreDataManager.isFavoritedCountryExists(countryID: self.countryID ?? "") {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"),for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart"),for: .normal)
        }
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.favoriteButton.alpha = 0.2
            self.favoriteButton.alpha = 1
        }
        
        if let countryID = countryID {
            if CoreDataManager.isFavoritedCountryExists(countryID: countryID) {
                CoreDataManager.deleteFavoritedCountry(countryID: countryID)
                favoriteButton.setImage(UIImage(systemName: "heart"),for: .normal)
                
            } else {
                favoriteButton.setImage(UIImage(systemName: "heart.fill"),for: .normal)
                let favoritedCountry = FavoritedCountry(context: context)
                favoritedCountry.code = self.countryID
                favoritedCountry.name = self.countryNameLabel.text
                CoreDataManager.addFavoriedCountry(favoritedCountry: favoritedCountry)
            }
        }
    }
    
}

