//
//  MainWeatherModel.swift
//  Weather
//
//  Created by RonchPonchPomkins on 10/01/2020.
//

class MainWeatherModel: Decodable {
    
    var temp1: Float = 0
    var temp_min1: Float = 0
    var temp_max1: Float = 0
    var feels_like1: Float = 0
    var temp: Int
    var temp_min: Int
    var temp_max: Int
    var feels_like: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, temp_min, temp_max, feels_like
    }

    init() {
        self.temp = Int(temp1)
        self.temp_min = Int(temp_min1)
        self.temp_max = Int(temp_max1)
        self.feels_like = Int(feels_like1)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = Int(try container.decodeIfPresent(Float.self, forKey: .temp) ?? 0)
        temp_min = Int(try container.decodeIfPresent(Float.self, forKey: .temp_min) ?? 0)
        temp_max = Int(try container.decodeIfPresent(Float.self, forKey: .temp_max) ?? 0)
        feels_like = Int(try container.decodeIfPresent(Float.self, forKey: .feels_like) ?? 0)
    }
}
