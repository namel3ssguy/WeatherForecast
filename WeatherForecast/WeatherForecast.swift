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
    
    var depictImageUrl: URL {
        switch type {
        case .clouds:
            return URL(string: "https://i.ibb.co/NyQr3TS/weather-2191838-1846632.png")!
        case .rain:
            return URL(string: "https://i.ibb.co/d7Kcp71/Weather-Rain-icon-1.png")!
        default:
            return URL(string: "https://i.ibb.co/JKW1BLk/sun-2551361-2149190.png")!
        }
    }
}

enum WeatherType: String {
    case rain = "Rain"
    case clouds = "Clouds"
    case clear = "Clear"
}
