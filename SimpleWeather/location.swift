//
//  ViewController.swift
//  gps
//
//  Created by apple on 10/5/16.
//  Copyright © 2016 haochenli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class location: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    
    
    var longtitude:Double=0
    var latitude  :Double=0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoom: UIButton!
    
    @IBOutlet weak var aniView: UIView!
       override func viewDidLoad()
    {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func zoom(sender: AnyObject)
    {
        aniView.startCanvasAnimation()
        if let _ = self.mapView
        {
            self.mapView.setRegion(MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
            latitude = self.mapView.userLocation.coordinate.latitude//important
            longtitude = self.mapView.userLocation.coordinate.longitude//important
            
        }
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        // let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        let center  = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:1,longitudeDelta:1))
        self.mapView.setRegion(region, animated: true)
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        //print (latitude ,"  ",longtitude)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("errors:" + error.localizedDescription)
    }
    
    
}

