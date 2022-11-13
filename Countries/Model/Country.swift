//
//  Country.swift
//  Countries
//
//  Created by Buse Topuz on 9.11.2022.
//

import Foundation

struct CountryResponse: Codable {
    let data: [Country]
}

struct Country: Codable {
    let code: String
    let name: String
}
