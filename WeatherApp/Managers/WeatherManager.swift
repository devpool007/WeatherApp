//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Devansh Sharma on 02.08.25.
//

import CoreLocation
import Foundation

class WeatherManager {
    
    let apiKey = Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String ?? ""

    func getCurrentWeather(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) async throws -> ResponseBody {
        guard let url = URL(
                string:
                    "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
            )
        else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
        
    }
}


