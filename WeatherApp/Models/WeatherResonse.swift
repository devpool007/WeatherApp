//
//  WeatherResonse.swift
//  WeatherApp
//
//  Created by Devansh Sharma on 02.08.25.
//

import Foundation

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody {
    static let preview: ResponseBody = ResponseBody(
        coord: CoordinatesResponse(lon: -74.006, lat: 40.7143),
        weather: [
            WeatherResponse(
                id: 804,
                main: "Clouds",
                description: "overcast clouds",
                icon: "04d"
            )
        ],
        main: MainResponse(
            temp: 3.42,
            feels_like: 0.51,
            temp_min: 1.36,
            temp_max: 5.28,
            pressure: 1015,
            humidity: 73
        ),
        name: "New York",
        wind: WindResponse(
            speed: 3.13,
            deg: 274
        )
    )
}
