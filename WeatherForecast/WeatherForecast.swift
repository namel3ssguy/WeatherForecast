//
//  WeatherForecastInfo.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import UIKit

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
    var main: String?
    
    var type: WeatherType? {
        if let main = main, !main.isEmpty {
            return WeatherType(rawValue: main)
        }
        return .clear
    }
    
    var depictImage: UIImage {
        switch type {
        case .clouds:
            return UIImage(systemName: "cloud.sun")!
        case .rain:
            return UIImage(systemName: "cloud.rain")!
        default:
            return UIImage(systemName: "sun.max")!
        }
    }
}

enum WeatherType: String {
    case rain = "Rain"
    case clouds = "Clouds"
    case clear = "Clear"
}
