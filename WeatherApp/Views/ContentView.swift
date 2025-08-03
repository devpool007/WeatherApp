//
//  ContentView.swift
//  WeatherApp
//
//  Created by Devansh Sharma on 02.08.25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                
                if let weather = weather{
                    WeatherView(weather: $weather, weatherManager: weatherManager, location: location)
                }
                else{
                    LoadingView()
                        .task {
                           await loadWeather(for: location)
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                }
                else {
                    WelcomeView().environmentObject(locationManager)
                }
            }  
            
            
        }
        .animation(.easeInOut, value: weather != nil)
        .background(Color(hue: 0.621, saturation: 0.885, brightness: 0.415))
        .preferredColorScheme(.dark)
        
        
    }
    
    func loadWeather(for location: CLLocationCoordinate2D) async {
        do {
            weather = try await weatherManager.getCurrentWeather(
                latitude: location.latitude,
                longitude: location.longitude
            )
        } catch {
            print("Error getting weather: \(error)")
        }
    }

}

#Preview {
    ContentView()
}
