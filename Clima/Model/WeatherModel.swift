//
//  WeatherModel.swift
//  Clima
//
//  Created by Vikram Singh on 5/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
struct  WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId {
        case 200...232://thunderstorm
            return "cloud.bolt"
        case 300...321://drizzle
            return "cloud.drizzle"
        case 500...531://rain
            return "cloud.rain"
        case 600...622://snow
            return "cloud.snow"
        case 701...781://fog
            return "cloud.fog"
        case 800://clear
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
