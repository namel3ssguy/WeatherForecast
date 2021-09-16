//
//  CacheManagerTests.swift
//  CacheManagerTests
//
//  Created by Minh Nguyen on 15/09/2021.
//

import XCTest
import RxSwift

@testable import WeatherForecast

class CacheManagerTests: XCTestCase {
    
    let city = "cityTestData"
    let numberOfForecaseDay = 7
    let units = "metric"
    
    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
     Test the convention of cached filename. It should look like city_numberOfForecaseDay_units
     */
    func testCachedFileNameConvention() throws {
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: 7, units: units)
        let tempDir = NSTemporaryDirectory()
        let fileName = "\(city)_\(numberOfForecaseDay)_\(units)"
        let result = tempDir.appending("\(fileName)")
        
        XCTAssertEqual(path, result, "Cached filename convention of weather data is wrong")
    }
    
    func testCachingWeatherForecastData() throws {
        let data = Data()
        try CacheManager.shared.cacheWeatherForecastData(data, withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
        let exist = FileManager.default.fileExists(atPath: path)
        XCTAssertTrue(exist, "Caching not working")
        try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
    }
    
    /**
     Test the findCachedWeatherForecastData can find the existing data.
     */
    func testFindCachedWeatherForecastData_Found() throws {
        let data = Data()
        try CacheManager.shared.cacheWeatherForecastData(data, withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
        CacheManager.shared.findCachedWeatherForecastData(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
            .subscribe { event in
                defer { try? FileManager.default.removeItem(at: URL(fileURLWithPath: path)) }
                switch event {
                case .success(let data):
                    XCTAssertTrue(data != nil, "findCachedWeatherForecastData couldn't find a existing file")
                case .failure(let error):
                    XCTAssertTrue(false, "findCachedWeatherForecastData error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    /**
     Test the findCachedWeatherForecastData doesn't find a not existing data.
     */
    func testFindCachedWeatherForecastData_NotFound() throws {
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: path))
        }
        CacheManager.shared.findCachedWeatherForecastData(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
            .subscribe { event in
                defer { try? FileManager.default.removeItem(at: URL(fileURLWithPath: path)) }
                switch event {
                case .success(let data):
                    XCTAssertTrue(data == nil, "findCachedWeatherForecastData couldn't find a existing file")
                case .failure(let error):
                    XCTAssertTrue(false, "findCachedWeatherForecastData error: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    /**
     Test cleanOldWeatherData removes only files from yesterday and backward.
     */
    func testCleanOldWeatherData() throws {
        let city1 = "cityTestData1"
        let city2 = "cityTestData2"
        
        try CacheManager.shared.cacheWeatherForecastData(Data(), withCity: city1, numberOfForecaseDay: numberOfForecaseDay, units: units)
        try CacheManager.shared.cacheWeatherForecastData(Data(), withCity: city2, numberOfForecaseDay: numberOfForecaseDay, units: units)
        let path1 = CacheManager.weatherForecastPath(withCity: city1, numberOfForecaseDay: numberOfForecaseDay, units: units)
        let path2 = CacheManager.weatherForecastPath(withCity: city2, numberOfForecaseDay: numberOfForecaseDay, units: units)
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let attrs = [FileAttributeKey.modificationDate: yesterday]
        try FileManager.default.setAttributes(attrs as [FileAttributeKey : Any], ofItemAtPath: path1)
        
        CacheManager.shared.cleanOldWeatherData()
            .subscribe({ event in
                defer {
                    try? FileManager.default.removeItem(at: URL(fileURLWithPath: path1))
                    try? FileManager.default.removeItem(at: URL(fileURLWithPath: path2))
                }
                
                switch event {
                case .success(_):
                    let isPath1Existing = FileManager.default.fileExists(atPath: path1)
                    let isPath2Existing = FileManager.default.fileExists(atPath: path2)
                    XCTAssertTrue(!isPath1Existing, "Removed old cached files failed.")
                    XCTAssertTrue(isPath2Existing, "Removed wrong old cahced files.")
                case .failure(_):
                    XCTAssertTrue(false, "Error while cleaning old cached files.")
                }
            })
            .disposed(by: disposeBag)
    }
}
