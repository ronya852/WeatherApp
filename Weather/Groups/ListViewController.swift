//
//  ListViewController.swift
//  Weather
//
//  Created by RonchPonchPomkins on 12/01/2020.
//

import Foundation
import UIKit
import SwiftyJSON

class ListViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startLabel: UILabel!
    
    // - Server
    private let session = URLSession.shared
    
    // - Data
    private let baseURL = "https://api.openweathermap.org/"
    private let apiKey = "" // YOUR API KEY
    var model = [WeatherViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        configure()
    }
        
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        configureCitySearchAllert()
        
    }
}

// MARK: - Data Source

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let weather = model[indexPath.item]
        cell.set(weather: weather)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.model.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Server logic

private extension ListViewController {
    
    func getWeather(city: String) {
        self.getWeatherAction()
        let urlString = baseURL + "data/2.5/weather?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) {  [weak self] data, response, error in
            if let data = data {
                let weather: WeatherModel = try! JSONDecoder().decode(WeatherModel.self, from: data)
                let weatherViewModel = WeatherViewModel(weather: weather)
                self?.model.append(weatherViewModel)

                DispatchQueue.main.async {
                    self?.getWeatherActionStop()
                    self?.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
}

// MARK: - Configure
private extension ListViewController {
    
    func configure() {
        configureTableViewView()
    }
    
    func configureTableViewView() {
        tableView.dataSource = self
    }
    
    func getWeatherAction() {
        startLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func getWeatherActionStop() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
        
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
