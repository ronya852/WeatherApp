//
//  WeatherModel.swift
//  Weather
//
//  Created by RonchPonchPomkins on 10/01/2020.
//

import Foundation

class WeatherModel: Decodable {
    
    var name = ""
    var main: MainWeatherModel
    
    enum CodingKeys: String, CodingKey {
        case name, main
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        main = try container.decodeIfPresent(MainWeatherModel.self, forKey: .main) ?? MainWeatherModel()
    }
}
