//
//  WeatherData.swift
//  Clima
//
//  Created by Eng.Aseel on 15/10/2024.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}
 

struct Main : Codable{
    let temp : Double
}

struct Weather : Codable{
    let id : Int
    let description: String
    
}
