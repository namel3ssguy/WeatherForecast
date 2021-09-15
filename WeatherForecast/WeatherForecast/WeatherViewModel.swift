//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import Moya
import Foundation
import RxMoya
import RxSwift

class WeatherViewModel {
    
    private let provider = MoyaProvider<WeatherTarget>()
    
    struct Constants {
        static let numberOfForecaseDay = 7
        static let units = "metric"
        static let appId = "60c6fbeb4b93ac653c492ba806fc346d"
    }
    
    func fetchWeatherForecast(for city: String) -> Single<WeatherForecast?> {
        CacheManager.shared.findCachedWeatherForecastData(withCity: city, numberOfForecaseDay: Constants.numberOfForecaseDay, units: Constants.units)
            .flatMap { [weak self] data -> Single<WeatherForecast?> in
                if let data = data {
                    let weatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    return Single.just(weatherForecast)
                } else if let sSelf = self {
                    return sSelf.requestWeatherForecast(for: city)
                } else {
                    return Single.just(nil)
                }
            }
    }
    
    func requestWeatherForecast(for city: String) -> Single<WeatherForecast?> {
        return provider.rx.request(.getWeather(city: city, numberOfForecaseDay: Constants.numberOfForecaseDay, appId: Constants.appId, units: Constants.units))
            .flatMap { response -> Single<WeatherForecast?> in
                do {
                    let weatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: response.data)
                    try CacheManager.shared.cacheWeatherForecastData(response.data, withCity: city, numberOfForecaseDay: Constants.numberOfForecaseDay, units: Constants.units)
                    return Single.just(weatherForecast)
                } catch {
                    return Single<WeatherForecast?>.error(error)
                }
            }
    }
}
