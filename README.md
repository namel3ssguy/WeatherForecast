# WeatherForecast
This project is writen in pure Swift. It applies MVVM as architectural patterns, reactive and functional programming with RxSwift. 

This app gets forecast information of 7 days (from today) of weather. When the weather data is fetched successfully, the app will cache the data for 1 day. For the place which has been cached, the app uses the cached data instead of making an API request. All the cached data stored in 'tmp' directory of the app, which is not synchronized when users backup the app. Everytime the app launches, it scans the cached data and deletes the old ones, which has modificationDate is not today.

## Features

- The UI looks like as sample design
- Include UnitTests
- Use MVVM as architectural patterns
- Support caching
- Support dynamic text
- Support VoiceOver
- All exceptions are handles (by using RxSwift)
- There're 3 weather icons of weather states are loaded remotely (I don't know they will be there when you check this project).

## Libraries

- Moya
- Kingfisher
- RxSwift
