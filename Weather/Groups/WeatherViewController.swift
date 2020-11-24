//
//  WeatherViewController.swift
//  Weather
//
//  Created by RonchPonchPomkins on 10/01/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minImage: UIImageView!
    @IBOutlet weak var maxImage: UIImageView!
    @IBOutlet weak var blackLine: UIImageView!
    
    // - Server
    private let session = URLSession.shared
    
    // - Data
    private let baseURL = "https://api.openweathermap.org/"
    private let apiKey = "" // YOUR API KEY
    var model = [WeatherViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        weatherImage.isHidden = true
        cityLabel.isHidden = true
        temperatureLabel.isHidden = true
        tempMinLabel.isHidden = true
        tempMaxLabel.isHidden = true
        feelsLikeLabel.isHidden = true
        descriptionLabel.isHidden = true
        maxImage.isHidden = true
        minImage.isHidden = true
        blackLine.isHidden = true
        
    }
    
    @IBAction func searchButton(_ sender: Any) {
        configureCitySearchAllert()
    }
    
    @IBAction func openList(_ sender: Any) {
        if let viewController = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }        
    }
}

// MARK: - Server logic

private extension WeatherViewController {
    
    func getWeather(city: String) {
        self.getWeatherAction()
        Alamofire.request(baseURL + "data/2.5/weather?q=\(city)&appid=\(apiKey)").responseJSON {
        response in
        if let responseStr = response.result.value {
            let jsonResponse = JSON(responseStr)
            let jsonWeather = jsonResponse["weather"].array![0]
            let jsonTemp = jsonResponse["main"]
            let icon = jsonWeather["icon"].stringValue
        
            self.cityLabel.text = jsonResponse["name"].stringValue
            if icon == "01d" {
                self.weatherImage.image = UIImage(named: "clearSky")
                    } else if icon == "01n" {
                        self.weatherImage.image = UIImage(named: "clearSky")
                    } else if icon == "02d" {
                        self.weatherImage.image = UIImage(named: "fewClouds")
                    } else if icon == "02n" {
                        self.weatherImage.image = UIImage(named: "fewClouds")
                    } else if icon == "03d" {
                        self.weatherImage.image = UIImage(named: "scatteredClouds")
                    } else if icon == "03n" {
                        self.weatherImage.image = UIImage(named: "scatteredClouds")
                    } else if icon == "04d" {
                        self.weatherImage.image = UIImage(named: "brokenClouds")
                    } else if icon == "04n" {
                        self.weatherImage.image = UIImage(named: "brokenClouds")
                    } else if icon == "09d" {
                        self.weatherImage.image = UIImage(named: "showerRain")
                    } else if icon == "09n" {
                        self.weatherImage.image = UIImage(named: "showerRain")
                    } else if icon == "10n" {
                        self.weatherImage.image = UIImage(named: "rain")
                    } else if icon == "10d" {
                        self.weatherImage.image = UIImage(named: "rain")
                    } else if icon == "11n" {
                        self.weatherImage.image = UIImage(named: "thunderstorm")
                    } else if icon == "11d" {
                        self.weatherImage.image = UIImage(named: "thunderstorm")
                    } else if icon == "13n" {
                        self.weatherImage.image = UIImage(named: "snow")
                    } else if icon == "13d" {
                        self.weatherImage.image = UIImage(named: "snow")
                    } else if icon == "50n" {
                        self.weatherImage.image = UIImage(named: "mist")
                    } else if icon == "50d" {
                        self.weatherImage.image = UIImage(named: "mist")
                    } else {
                        self.weatherImage.image = UIImage(named: "mist")
                    }
            
            self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue))-273)°"
            self.tempMinLabel.text = "\(Int(round(jsonTemp["temp_min"].doubleValue))-273)°"
            self.tempMaxLabel.text = "\(Int(round(jsonTemp["temp_max"].doubleValue))-273)°"
            self.feelsLikeLabel.text = "FEELS LIKE \(Int(round(jsonTemp["feels_like"].doubleValue))-273)°"
            self.descriptionLabel.text = jsonWeather["description"].stringValue
            
            self.getWeatherActionStop()
        }
        }
    }
}

// MARK: - Configure

private extension WeatherViewController {
    
    func getWeatherAction() {
        startLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func getWeatherActionStop() {
        activityIndicator.isHidden = true
        weatherImage.isHidden = false
        cityLabel.isHidden = false
        temperatureLabel.isHidden = false
        tempMinLabel.isHidden = false
        tempMaxLabel.isHidden = false
        feelsLikeLabel.isHidden = false
        descriptionLabel.isHidden = false
        maxImage.isHidden = false
        minImage.isHidden = false
        blackLine.isHidden = false
        animationImage()
        activityIndicator.stopAnimating()
    }
}
    
// MARK: - Configure

private extension WeatherViewController {
    
    func animationImage() {
        imageConstraint.constant = 100
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }
        )}
    
    func configureCitySearchAllert() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black

        let titleFont  = "SELECT A CITY"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: titleFont as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Futura Medium", size: 18.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length: titleFont.count))
        alertController.setValue(myMutableString, forKey: "attributedTitle")

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter City Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            self.getWeather(city: textField.text!)

        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

