//
//  CountryDetail.swift
//  Countries
//
//  Created by Buse Topuz on 9.11.2022.
//

import Foundation

struct CountryDetailData: Codable {
    var data: CountryDetail?
}
    
struct CountryDetail: Codable {
    var code: String?
    var flagImageURI: String?
    var name: String?
    var wikiDataID: String?

    enum CodingKeys: String, CodingKey {
        case code, name
        case flagImageURI = "flagImageUri"
        case wikiDataID = "wikiDataId"
    }
}
