//
//  SavedViewController.swift
//  Countries
//
//  Created by Buse Topuz on 10.11.2022.
//

import UIKit

class SavedViewController: UIViewController {
    
    private var countries: [FavoritedCountry] = [] {
        didSet {
            favoriteCountriesTableView.reloadData()
        }
    }
    @IBOutlet weak var favoriteCountriesTableView: UITableView! {
        didSet {
            favoriteCountriesTableView.delegate = self
            favoriteCountriesTableView.dataSource = self
            favoriteCountriesTableView.register(UINib(nibName: String.init(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String.init(describing: CountryTableViewCell.self))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.loadFavoriteCountries()
        favoriteCountriesTableView.reloadData()
    }
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.favoriteCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        let countryID = CoreDataManager.favoriteCountries[indexPath.row].code
        cell.countryID = countryID
        cell.setup(model: Country(code: CoreDataManager.favoriteCountries[indexPath.row].code ?? "", name: CoreDataManager.favoriteCountries[indexPath.row].name ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryDetailVC") as! DetailViewController
        detailVC.countryID = CoreDataManager.favoriteCountries[indexPath.row].code ?? ""
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
