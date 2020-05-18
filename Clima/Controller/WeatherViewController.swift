//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController{
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization() 
        locationManager.requestLocation()
    }
}

 //MARK: - Location Manager Delegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("text field should return was called")
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field did end editing")
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text  = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true;
        }
        textField.placeholder = "Type something"
        return false;
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

 //MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        //searchTextField.text
        print("search was pressed.")
        searchTextField.endEditing(true)
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        print("get current location")
        locationManager.requestLocation()
        
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        print("did update weather")
        print(weather.conditionName)
        print(weather.temperatureString)
        print(weather.cityName)
        
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            
        }
        print(weather.temperature)
    }
}
