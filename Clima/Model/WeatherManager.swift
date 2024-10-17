//
//  Untitled.swift
//  Clima
//
//  Created by Eng.Aseel on 15/10/2024.
//
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather : WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ace6aa60de1a0fa87381e5372a738d19&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String)  {
        let urlString = weatherURL + "&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees)  {
        let urlString = weatherURL + "&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString : String){
        if let url = URL(string : urlString){
            let session = URLSession(configuration: .default)
            let task =
            session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather  = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self ,weather : weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        let jsonDecoder =  JSONDecoder()
        do {
            let decodedData =  try jsonDecoder.decode(WeatherData.self , from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weatherModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }}
    


