//
//  ListTableViewCell.swift
//  Weather
//
//  Created by RonchPonchPomkins on 12/01/2020.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // - UI
    @IBOutlet weak var cityLabelCell: UILabel!
    @IBOutlet weak var temperatureLabelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(weather: WeatherViewModel) {
        cityLabelCell.text = weather.weather.name
        temperatureLabelCell.text = "\(((weather.weather.main.temp)-273))°"
    }
}
