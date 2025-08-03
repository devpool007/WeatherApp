//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Devansh Sharma on 02.08.25.
//

import SwiftUI
import CoreLocation

func mapWeatherToIcon(_ weatherMain: String) -> String {
    switch weatherMain {
    case "Thunderstorm":
        return "cloud.bolt.rain.fill"
    case "Drizzle":
        return "cloud.drizzle.fill"
    case "Rain":
        return "cloud.rain.fill"
    case "Snow":
        return "cloud.snow.fill"
    case "Clear":
        return "sun.max.fill"
    case "Clouds":
        return "cloud.fill"
    case "Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado":
        return "cloud.fog.fill"
    default:
        return "questionmark.circle"
    }
}


struct WeatherView: View {

    @Binding var weather: ResponseBody?
    var weatherManager: WeatherManager
    var location: CLLocationCoordinate2D
    @State var todayDate = Date().formatted(.dateTime.month().day().hour().minute())
    
    var body: some View {
            
      
            ZStack(alignment: .leading){
                ScrollView{
                    VStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(weather?.name ?? "Loading city...")
                                .bold().font(.title)
                            
                            Text("\(todayDate)")
                                .fontWeight(.light)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                
                                VStack(spacing: 20) {
                                    Image(systemName: mapWeatherToIcon(weather?.weather[0].main ?? "Loading weather..."))
                                        .font(.system(size: 40))
                                    Text(weather?.weather[0].main ?? "Maybe cloudy...")
                                }.frame(width: 150, alignment: .leading)
                                
                                Spacer()
                                
                                Text((weather?.main.feels_like.roundDouble() ?? "Getting temp...") + "°")
                                    .font(.system(size: 80))
                                    .fontWeight(.bold)
                                    .padding()
                                
                            }
                            
                            Spacer().frame(height: 80)
                            
                            AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) {
                                image in image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Spacer()
                            
                        }.frame(maxWidth: .infinity)
                        
                    }.padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 20 ){
                            Text("Weather now")
                                .bold().padding(.bottom)
                            HStack{
                                WeatherRow(logo: "thermometer", name: "Min temp", value: (weather?.main.temp_min.roundDouble() ?? "0") + "°")
                                Spacer()
                                WeatherRow(logo: "thermometer", name: "Max temp", value: weather?.main.temp_max.roundDouble() ?? "100" + "°")
                            }
                            
                            HStack{
                                WeatherRow(logo: "wind", name: "Wind speed", value: weather?.wind.speed.roundDouble() ?? "0" + "m/s")
                                Spacer()
                                WeatherRow(logo: "humidity", name: "Humidity", value: weather?.main.humidity.roundDouble() ?? "Getting humidity..." + "%")
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(Color(hue: 0.621, saturation: 0.885, brightness: 0.415))
                        .background(.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                        
                    }
                    
                }.refreshable {
                    await fetchWeather()
                }
                
            }.edgesIgnoringSafeArea(.bottom)
                .background(Color(hue: 0.621, saturation: 0.885, brightness: 0.415))
                .preferredColorScheme(.dark)
        }
    
    func fetchWeather() async {
        do {
            weather = try await weatherManager.getCurrentWeather(
                latitude: location.latitude,
                longitude: location.longitude
            )
            todayDate = Date().formatted(.dateTime.month().day().hour().minute()) // update date
        } catch {
            print("Error refreshing weather: \(error)")
        }
    }
    
}

#Preview {
    StatefulPreviewWrapper(ResponseBody.preview) { mockWeather in
        WeatherView(
            weather: mockWeather,
            weatherManager: WeatherManager(),
            location: CLLocationCoordinate2D(latitude: 48.137154, longitude: 11.576124)
        )
    }
}


    
