# WeatherForecast
This project is writen in pure Swift. It applies MVVM as architectural patterns, reactive and functional programming with RxSwift. It uses Swift Package Manager as dependencies manager.

This app gets weather forecast information of 7 days (from today) for the city which is typed in the search box. 

## Caching mechanism

When the weather data is fetched successfully, the app will cache the data till the end of the day. For the places which have been cached, the app uses the cached data instead of making an API requests. All the cached data is stored in 'tmp' directory of the app, which is not synchronized when users backup the app. Everytime the app launches, it scans the cached data and deletes the old ones, which is not today.

## Features

- The UI looks like as sample design
- Include Unit Tests
- Use MVVM as the architectural pattern
- Support caching
- Support dynamic text
- Support VoiceOver
- All exceptions are handled
- There're 3 weather icons of weather states which are loaded remotely (I'm not sure they will be there when you check this project).

## Libraries

- Moya
- Kingfisher 
- RxSwift

![Simulator Screen Shot - iPhone 12 Pro - 2021-09-17 at 08 08 24](https://user-images.githubusercontent.com/9659760/133708664-59c5c466-b1eb-4454-ac05-86b93d7b33ba.png)
