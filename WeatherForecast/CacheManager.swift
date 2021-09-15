//
//  CacheManager.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import Foundation
import RxSwift

class CacheManager {
    
    static let shared = CacheManager()
    
    /**
     Cache weather data to a file.
     */
    func cacheWeatherForecastData(_ data: Data, withCity city: String, numberOfForecaseDay: Int, units: String) throws {
        let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
        let url = URL(fileURLWithPath: path)
        try data.write(to: url)
        print("Cached weather data to \(path)")
    }
    
    /**
     Get the weather data path. The cached filename convension is 'city_numberOfDay_units'.
     */
    static func weatherForecastPath(withCity city: String, numberOfForecaseDay: Int, units: String) -> String {
        let tempDir = NSTemporaryDirectory()
        let fileName = "\(city)_\(numberOfForecaseDay)_\(units)"
        let path = tempDir.appending("\(fileName)")
        return path
    }
    
    /**
     Find the cached data file. If any, return corresponding data. Otherwise, return nil.
     */
    func findCachedWeatherForecastData(withCity city: String, numberOfForecaseDay: Int, units: String) -> Single<Data?> {
        return Single<Data?>.create { single in
            let path = CacheManager.weatherForecastPath(withCity: city, numberOfForecaseDay: numberOfForecaseDay, units: units)
            if FileManager.default.fileExists(atPath: path) {
                do {
                    let url = URL(fileURLWithPath: path)
                    let attrs = try FileManager.default.attributesOfItem(atPath: path)
                    let modificationDate = attrs[FileAttributeKey.modificationDate] as! Date
                    let currentDate = Date()
                    
                    if modificationDate.isSameDay(with: currentDate) {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path))
                        print("Found cached weather data at \(path)")
                        single(.success(data))
                    } else {
                        try FileManager.default.removeItem(at: url)
                        single(.success(nil))
                    }
                } catch {
                    single(.failure(error))
                }
            } else {
                single(.success(nil))
            }
            return Disposables.create()
        }
    }
    
    /**
     Clean the old weather data files which are not them same as today.
     */
    func cleanOldWeatherData() -> Single<Void?> {
        return Single<Void?>.create { single in
            do {
                let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: NSTemporaryDirectory()), includingPropertiesForKeys: [.attributeModificationDateKey])
                for file in files {
                    let attrs = try FileManager.default.attributesOfItem(atPath: file.path)
                    let modificationDate = attrs[FileAttributeKey.modificationDate] as! Date
                    let currentDate = Date()
                    
                    if !modificationDate.isSameDay(with: currentDate) {
                        try FileManager.default.removeItem(at: file)
                    }
                }
                single(.success(nil))
            } catch {
                print("Clean old weather data error: \(error)")
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}

// MARK: - Date Utils

extension Date {
    
    func isSameDay(with date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}
