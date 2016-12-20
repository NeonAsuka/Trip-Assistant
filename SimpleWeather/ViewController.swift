
import UIKit
import CoreLocation
import Canvas

class ViewController: UIViewController,
                      WeatherGetterDelegate,
                      CLLocationManagerDelegate,
                      UITextFieldDelegate
{
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var Cityname: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cloudCoverLabel: UILabel!
  @IBOutlet weak var windLabel: UILabel!
  @IBOutlet weak var rainLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var getLocationWeatherButton: UIButton!
  
    @IBOutlet weak var aniView: CSAnimationView!
    
    
  let locationManager = CLLocationManager()
  var weather: WeatherGetter!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
       
    
    weather = WeatherGetter(delegate: self)
    
    
    cityLabel.text = "weather"
    weatherLabel.text = ""
    temperatureLabel.text = ""
    cloudCoverLabel.text = ""
    windLabel.text = ""
    rainLabel.text = ""
    humidityLabel.text = ""
    
    getLocation()
    getLocationWeatherButton.layer.cornerRadius = 9

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  @IBAction func getWeatherForLocationButtonTapped(sender: UIButton) {
    aniView.startCanvasAnimation()
    setWeatherButtonStates(false)
    getLocation()
    
      }
 
    
    func setWeatherButtonStates(state: Bool) {
        getLocationWeatherButton.enabled = state
    }

    
  func didGetWeather(weather: Weather) {
    
    dispatch_async(dispatch_get_main_queue()) {
      self.cityLabel.text = weather.city
      self.weatherLabel.text = weather.weatherDescription
      self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
      self.cloudCoverLabel.text = "\(weather.cloudCover)%"
      self.windLabel.text = "\(weather.windSpeed) m/s"
      
        
      if let rain = weather.rainfallInLast3Hours {
        self.rainLabel.text = "\(rain) mm"
      }
      else {
        self.rainLabel.text = "None"
      }
      
      self.humidityLabel.text = "\(weather.humidity)%"
      self.getLocationWeatherButton.enabled = true
    }
  }
  
  func didNotGetWeather(error: NSError) {
    
    dispatch_async(dispatch_get_main_queue()) {
      self.showSimpleAlert(title: "Can't get the weather",
                           message: "The weather service isn't responding.")
      self.getLocationWeatherButton.enabled = true
    }
    print("didNotGetWeather error: \(error)")
  }
  
  
  // MARK: - CLLocationManagerDelegate and related methods
  
  func getLocation() {
    guard CLLocationManager.locationServicesEnabled() else {
      showSimpleAlert(
        title: "Please turn on location services",
        message: "This app needs location services in order to report the weather " +
                 "for your current location.\n" +
                 "Go to Settings → Privacy → Location Services and turn location services on."
      )
      getLocationWeatherButton.enabled = true
      return
    }
    
    let authStatus = CLLocationManager.authorizationStatus()
    guard authStatus == .AuthorizedWhenInUse else {
      switch authStatus {
        case .Denied, .Restricted:
          let alert = UIAlertController(
            title: "Location services for this app are disabled",
            message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
            preferredStyle: .Alert
          )
          let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
          let openSettingsAction = UIAlertAction(title: "Open Settings", style: .Default) {
            action in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
              UIApplication.sharedApplication().openURL(url)
            }
          }
          alert.addAction(cancelAction)
          alert.addAction(openSettingsAction)
          presentViewController(alert, animated: true, completion: nil)
          getLocationWeatherButton.enabled = true
          return
          
        case .NotDetermined:
          locationManager.requestWhenInUseAuthorization()
          
        default:
          print("Oops! Shouldn't have come this far.")
      }
      
      return
    }
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    locationManager.requestLocation()
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let newLocation = locations.last!
    weather.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                    longitude: newLocation.coordinate.longitude)
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        dispatch_async(dispatch_get_main_queue()) {
      self.showSimpleAlert(title: "Can't determine your location",
                           message: "The GPS and other location services aren't responding.")
    }
    print("locationManager didFailWithError: \(error)")
  }
  
  
 
    
  func showSimpleAlert(title title: String, message: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .Alert
    )
    let okAction = UIAlertAction(
      title: "OK",
      style:  .Default,
      handler: nil
    )
    alert.addAction(okAction)
    presentViewController(
      alert,
      animated: true,
      completion: nil
    )
  }
  
}


