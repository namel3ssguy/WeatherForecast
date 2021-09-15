//
//  WeatherForecastInfo.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import Foundation

struct WeatherForecast: Codable {
    
    var cod: String?
    var list: [WeatherItem]?
}

struct WeatherItem: Codable {
    
    var dt: Int?
    var temp: WeatherTemperature?
    var pressure: Int?
    var humidity: Int?
    var weather: [WeatherInfo]?
    
    var date: String {
        if let dt = dt {
            let date = Date(timeIntervalSince1970: TimeInterval(dt))
            let df = DateFormatter()
            df.dateFormat = "EEE, dd MMM yyyy"
            return df.string(from: date)
        }
        return ""
    }
}

struct WeatherTemperature: Codable {
    
    var eve: Float?
}

struct WeatherInfo: Codable {
    
    var description: String?
}
