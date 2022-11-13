//
//  NetworManager.swift
//  Countries
//
//  Created by Buse Topuz on 13.11.2022.
//

import Foundation

enum Router {
    case getCountries
    case getCountryDetail(countryCode: String)
    
    var scheme: String {
        switch self {
        case .getCountries, .getCountryDetail:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .getCountries, .getCountryDetail:
            return "wft-geo-db.p.rapidapi.com"
        }
    }
    
    var path: String {
        switch self {
        case .getCountries:
            return "/v1/geo/countries/"
        case .getCountryDetail (let countryCode):
            return "/v1/geo/countries/" + countryCode + "/"
        }
    }
    
    var parameters: [URLQueryItem] {
        let apiKey = NetworkConstant.apiKey
        switch self {
        case .getCountries:
            return [URLQueryItem(name: "limit", value: "10"),
                    URLQueryItem(name: "X-RapidAPI-Key", value: apiKey)]
        case .getCountryDetail:
            return [ URLQueryItem(name: "X-RapidAPI-Key", value: apiKey)]
        }
    }
    
    var method: String {
        switch self {
        case .getCountries, .getCountryDetail:
            return "GET"
        }
    }
}

