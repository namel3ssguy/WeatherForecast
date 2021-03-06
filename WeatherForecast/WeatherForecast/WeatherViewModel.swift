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
    
    private let disposeBag = DisposeBag()
    
    private var provider: MoyaProvider<WeatherTarget>
    
    init(provider: MoyaProvider<WeatherTarget> = MoyaProvider<WeatherTarget>()) {
        self.provider = provider
    }
    
    var weatherForecast: BehaviorSubject<WeatherForecast?> = BehaviorSubject(value: nil)
    
    var error: BehaviorSubject<Error?> = BehaviorSubject(value: nil)
    
    struct Constants {
        static let numberOfForecaseDay = 7
        static let units = "metric"
        static let appId = "60c6fbeb4b93ac653c492ba806fc346d"
        static let validCityLength = 3
    }
    
    func getWeatherForecastInfo(for city: String) {
        if city.trimmingCharacters(in: .whitespacesAndNewlines).count >= Constants.validCityLength {
            fetchWeatherForecast(for: city)
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
                .subscribe { [weak self] event in
                    switch event {
                    case .success(let weatherForecast):
                        self?.weatherForecast.onNext(weatherForecast)
                    case .failure(let error):
                        self?.error.onNext(error)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
    
    /**
     Fetch the weather forecast data. If the cached data found, use it. If not, make a request to get the data.
     */
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
    
    /**
     Request the weather forecast data. If succeed, the app cached the data for later use.
     */
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
