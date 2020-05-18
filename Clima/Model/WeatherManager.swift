//
//  WeatherManager.swift
//  Clima
//
//  Created by Vikram Singh on 5/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation 
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=621f44d2d66f7d0e025380710c14897f&units=imperial"
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        print("the city name:" + cityName + ".")
        let cityNameCopy = cityName.copy()
        let urlString = "\(weatherURL)&q=\(cityNameCopy)"
        print(urlString)
        performRequest(urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String){
        print(urlString)
        if let url = URL(string: weatherURL){
            print("performing request")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                if error != nil{
                    print("there was an error.")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    let dataString = String(data: safeData, encoding: .utf8)
                    print("DATA STRING \(dataString!)")
                    print("an error between if lets.")
                    if let weather = self.parseJSON(safeData){
                        print("no errors in handle")
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            })
            task.resume()
        }
    }
    
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        print("parse json ran.")
        let decoder = JSONDecoder()
        do{
            print("before decoding data")
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("after decoding data")
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            print(name)
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            //let conditionName = weather.conditionName
        }catch{
            print("there was an error while parsing the json")
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
