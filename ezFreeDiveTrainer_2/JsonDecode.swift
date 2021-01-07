//
//  JsonDecode.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/5.
//

import Foundation

struct Weather: Codable {
    var records: records
}

struct records: Codable {
    var location: [location]
}

struct location: Codable {
    var parameter: [parameter]
    var weatherElement:[weatherElement]
}

struct weatherElement: Codable {
    var elementName: String
    var elementValue: String
}

struct parameter: Codable {
    var parameterName: String
    var parameterValue: String
}
