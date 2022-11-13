//
//  ViewController.swift
//  Countries
//
//  Created by Buse Topuz on 9.11.2022.
//

import UIKit

class HomeViewController: UIViewController {
    private var countries: [Country] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: String(describing: CountryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CountryTableViewCell.self))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
        CoreDataManager.loadFavoriteCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func fetchCountries() {
        ServiceLayer.shared.request(router: Router.getCountries) { (result: Result<CountryResponse, Error>) in
            switch result {
            case .success (let response):
                self.countries = response.data
            case .failure (let error):
                print(error)
            }
        }
    }
}
//MARK: - TableView Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self), for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        cell.countryID = countries[indexPath.row].code
        cell.setup(model: Country(code: countries[indexPath.row].code , name: countries[indexPath.row].name ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryDetailVC") as! DetailViewController
        detailVC.countryID = countries[indexPath.row].code
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
