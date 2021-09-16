//
//  WeatherTarget.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import Foundation
import Moya

enum WeatherTarget {
    case getWeather(city: String, numberOfForecaseDay: Int, appId: String, units: String)
}

extension WeatherTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    var path: String {
        switch self {
        case .getWeather(_, _, _, _):
            return "/data/2.5/forecast/daily"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeather(_, _, _, _):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getWeather(let city, let numberOfForecaseDay, let appId, let units):
            let query: [String: Any] = [
                "q": city,
                "cnt": numberOfForecaseDay,
                "appid": appId,
                "units": units
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .getWeather(_, _, _, _):
            return "{\"cod\": \"200\"}".data(using: .utf8)!
        }
    }
}
