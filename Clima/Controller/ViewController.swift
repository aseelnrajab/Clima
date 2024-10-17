//
//  ViewController.swift
//  Clima
//
//  Created by Eng.Aseel on 02/10/2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
               
        weatherManager.delegate = self
        searchTextField.delegate = self
       
    }

   

}

//MARK: - UITextFieldDelegate

extension ViewController : UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       if let cityName = textField.text{
           weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextField.text = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type Something"
            return false
        }
    }
}
//MARK: - WeatherManagerDelegate

extension ViewController : WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager , weather : WeatherModel){
        DispatchQueue.main.async {
            self.tempratureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName

        }
    }
    func didFailWithError(error: any Error) {
        print(error)
    }
}
//MARK: - LocationManagerDelegate

extension ViewController : CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if  let loction = locations.last {
            locationManager.stopUpdatingLocation()
          let lat = loction.coordinate.latitude
           let lon = loction.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
            }
  
}


