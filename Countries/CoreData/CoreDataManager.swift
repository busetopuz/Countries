//
//  CoreDataManager.swift
//  Countries
//
//  Created by Buse Topuz on 13.11.2022.
//


import Foundation
import CoreData
import UIKit

internal let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class CoreDataManager {
    
    static var favoriteCountries: [FavoritedCountry] = []
    
    static func saveContext(){
        do {
            try context.save()
        } catch {
            print("Error on saving data \(error)")
        }
    }
    
    static func addFavoriedCountry(favoritedCountry: FavoritedCountry) {
        CoreDataManager.favoriteCountries.append(favoritedCountry)
        CoreDataManager.saveContext()
    }
    
    static func loadFavoriteCountries() {
        let request:NSFetchRequest<FavoritedCountry> = FavoritedCountry.fetchRequest()
        do {
            favoriteCountries = try context.fetch(request)
            favoriteCountries.reverse()
        } catch {
            print("Error fetching data \(error)")
        }
    }
    
    static func isFavoritedCountryExists(countryID: String) -> Bool {
        loadFavoriteCountries()
        for favoritedCountry in favoriteCountries {
            if countryID == favoritedCountry.code {
                return true
            }
        }
        return false
    }
    
    static func deleteFavoritedCountry(countryID: String?) {
        if let countryID = countryID {
            for favoritedCountry in favoriteCountries {
                if countryID == favoritedCountry.code {
                    context.delete(favoritedCountry)
                    saveContext()
                    loadFavoriteCountries()
                    return
                }
            }
        }
    }
}
