//
//  WeatherViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Minh Nguyen on 16/09/2021.
//

import XCTest
import RxSwift
import Moya

@testable import WeatherForecast

class WeatherViewModelTests: XCTestCase {
    
    private var viewModel: WeatherViewModel!
    
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        viewModel = WeatherViewModel(provider: MoyaProvider<WeatherTarget>(stubClosure: MoyaProvider<WeatherTarget>.immediatelyStub))
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    /**
     Test the request succeeds and the data is cached.
     */
    func testRequestWeatherForecast() throws {
        let city = "cityTestData"
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: WeatherViewModel.Constants.numberOfForecaseDay, units: WeatherViewModel.Constants.units)
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        
        viewModel.requestWeatherForecast(for: city)
            .subscribe { event in
                defer {
                    if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
                    }
                }
                switch event {
                case .success(let weatherForecast):
                    XCTAssertNotNil(weatherForecast, "Fetching weather forecast not working")
                    let fileExist = FileManager.default.fileExists(atPath: path)
                    XCTAssertTrue(fileExist, "Fetching weather forecast not caching data")
                case .failure(let error):
                    XCTFail("requestWeatherForecast test error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    /**
     Test request data from server and cached the data successfully.
     */
    func testFetchWeatherForecast_cachedDataNotExisting() throws {
        let city = "cityTestData"
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: WeatherViewModel.Constants.numberOfForecaseDay, units: WeatherViewModel.Constants.units)
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        viewModel.fetchWeatherForecast(for: city)
            .subscribe { event in
                defer {
                    if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
                    }
                }
                switch event {
                case .success(let weatherForecast):
                    XCTAssertNotNil(weatherForecast, "Fetching weather forecast not working")
                    let fileExist = FileManager.default.fileExists(atPath: path)
                    XCTAssertTrue(fileExist, "Fetching weather forecast not caching data")
                case .failure(let error):
                    XCTFail("retchWeatherForecast test error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    /**
     Test the valid cached data should be used instead of make request to server.
     */
    func testFetchWeatherForecast_cachedDataExisting() throws {
        let city = "cityTestData"
        let cod = "test_200" // Use this cod as the verified data. The fetching data should be the same as this content.
        let data = "{\"cod\": \"\(cod)\"}".data(using: .utf8)!
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: WeatherViewModel.Constants.numberOfForecaseDay, units: WeatherViewModel.Constants.units)
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        try CacheManager.shared.cacheWeatherForecastData(data, withCity: city, numberOfForecaseDay: WeatherViewModel.Constants.numberOfForecaseDay, units: WeatherViewModel.Constants.units)
        viewModel.fetchWeatherForecast(for: city)
            .subscribe { event in
                defer {
                    if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.removeItem(at: URL(fileURLWithPath: path))
                    }
                }
                switch event {
                case .success(let weatherForecast):
                    XCTAssertNotNil(weatherForecast, "Fetching weather forecast not working")
                    XCTAssertEqual(weatherForecast?.cod, "test_200", "The fetchWeatherForecast")
                    let fileExist = FileManager.default.fileExists(atPath: path)
                    XCTAssertTrue(fileExist, "Fetching weather forecast not caching data")
                case .failure(let error):
                    XCTFail("retchWeatherForecast test error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
}
