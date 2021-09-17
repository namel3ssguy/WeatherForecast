//
//  WeatherForecastCell.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import UIKit

class WeatherForecastCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var weatherItem: WeatherItem? {
        didSet {
            updateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.useDynamicFont(forTextStyle: .body)
        temperatureLabel.useDynamicFont(forTextStyle: .body)
        pressureLabel.useDynamicFont(forTextStyle: .body)
        humidityLabel.useDynamicFont(forTextStyle: .body)
        descLabel.useDynamicFont(forTextStyle: .body)
    }
    
    private func updateData() {
        let date = weatherItem?.date ?? ""
        dateLabel.text = "Date: \(date)"
        let temp = String(weatherItem?.temp?.eve ?? 0)
        temperatureLabel.text = "Average Temperature: \(temp) °C"
        let pressure = String(weatherItem?.pressure ?? 0)
        pressureLabel.text = "Pressure: \(pressure)"
        let humidity = String(weatherItem?.humidity ?? 0)
        humidityLabel.text = "Humidity: \(humidity)%"
        let desc = weatherItem?.weather?.first?.description ?? ""
        descLabel.text = "Description: \(desc)"
        if let depictImageUrl = weatherItem?.weather?.first?.depictImageUrl {
            weatherImageView.setImage(from: depictImageUrl)
        } else {
            weatherImageView.image = nil
        }
        
        weatherImageView.accessibilityTraits = .image
        weatherImageView.isAccessibilityElement = true
        weatherImageView.accessibilityLabel =  "Weather is mainly \(weatherItem?.weather?.first?.main ?? "")"
    }
}
