//
//  currency.swift
//  SimpleWeather
//
//  Created by apple on 21/10/2016.
//  Copyright © 2016 haochenli. All rights reserved.
//

import Foundation


protocol WeatherGetterDelegate {
  func didGetWeather(weather: Weather)
  func didNotGetWeather(error: NSError)
}


class WeatherGetter {
  
  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "06db44f389d2172e9b1096cdce7b051c"
 
  private var delegate: WeatherGetterDelegate
  
  
  // MARK: -
  
  init(delegate: WeatherGetterDelegate) {
    self.delegate = delegate
  }
  
 
  
  func getWeatherByCoordinates(latitude latitude: Double, longitude: Double) {
    let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
    getWeather(weatherRequestURL)
  }
  
  private func getWeather(weatherRequestURL: NSURL) {
    
    let session = NSURLSession.sharedSession()
    session.configuration.timeoutIntervalForRequest = 3
    
    let dataTask = session.dataTaskWithURL(weatherRequestURL) {
      (data: NSData?, response: NSURLResponse?, error: NSError?) in
      if let networkError = error {
              self.delegate.didNotGetWeather(networkError)
      }
      else {
               do {
          let weatherData = try NSJSONSerialization.JSONObjectWithData(
            data!,
            options: .MutableContainers) as! [String: AnyObject]
         // print(weatherData)
         
          let weather = Weather(weatherData: weatherData)
                   self.delegate.didGetWeather(weather)
                print (weather.country)
        }
        catch let jsonError as NSError {
          self.delegate.didNotGetWeather(jsonError)
        }
      }
    }
    
    dataTask.resume()
  }
  
}


