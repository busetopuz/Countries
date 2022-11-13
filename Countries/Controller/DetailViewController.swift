//
//  DetailViewController.swift
//  Countries
//
//  Created by Buse Topuz on 10.11.2022.
//

import UIKit
import Kingfisher
import CoreData
import SVGKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var forMoreInformationButton: UIButton!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    private var countryDetail: CountryDetailData? {
        didSet {
            setup()
            loadImage()
        }
    }
    
    var countryID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCheck()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        setup()
        favoriteCheck()
    }
    
    private func getData(){
        ServiceLayer.shared.request(router: Router.getCountryDetail(countryCode: countryID ?? "")) { (result: Result<CountryDetailData, Error>) in
            switch result {
            case .success (let response):
                self.countryDetail = response
                self.setup()
                self.loadImage()
                self.informationChecked()
            case .failure (let error):
                print(error)
            }
        }
    }
    
    func setup() {
        countryCodeLabel.text = countryDetail?.data?.code
        navigationItem.title = countryDetail?.data?.name
    }
    
    func favoriteCheck(){
        if CoreDataManager.isFavoritedCountryExists(countryID: countryID ?? "") {
            self.favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            self.favoriteButton.image = UIImage(systemName: "heart")
        }
    }
    
    @IBAction func informationButtonClicked(_ sender: UIButton) {
        let wikiID = countryDetail?.data?.wikiDataID ?? ""
        guard let url = URL(string: "https://www.wikidata.org/wiki/\(wikiID)" ) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func favoriteButtonClicked(_ sender: UIBarButtonItem) {
        if let countryID = countryID {
            if CoreDataManager.isFavoritedCountryExists(countryID: countryID) {
                CoreDataManager.deleteFavoritedCountry(countryID: countryID)
                self.favoriteButton.image = UIImage(systemName: "heart")
            } else {
                self.favoriteButton.image = UIImage(systemName: "heart.fill")
                let favoritedCountry = FavoritedCountry(context: context)
                favoritedCountry.code = self.countryID
                favoritedCountry.name = self.countryDetail?.data?.name
                CoreDataManager.addFavoriedCountry(favoritedCountry: favoritedCountry)
            }
        }
    }
    
    func informationChecked() {
        if countryDetail?.data?.wikiDataID == nil {
            forMoreInformationButton.backgroundColor = .gray
            forMoreInformationButton.isEnabled = false
        }
    }
    
    func loadImage() {
        if countryDetail?.data?.flagImageURI != nil {
            let imageURL = URL(string: countryDetail?.data?.flagImageURI ?? "" )
            countryFlagImageView.kf.setImage(with: imageURL, options: [.processor(SVGImgProcessor())])
        } else {
            countryFlagImageView.image = #imageLiteral(resourceName: "no-image-found-360x250")
        }
    }
    
}
