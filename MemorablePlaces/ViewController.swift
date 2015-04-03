//
//  ViewController.swift
//  MemorablePlaces
//
//  Created by Gaurav Konchady on 4/1/15.
//  Copyright (c) 2015 Gaurav Konchady. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {

    var manager: CLLocationManager!
    
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "addLocation:")
        uilpgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilpgr)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location: CLLocation = locations[0] as CLLocation
        var latitude = location.coordinate.latitude
        var longitude = location.coordinate.longitude
        var coordinate = CLLocationCoordinate2DMake(latitude , longitude)
        var latDelta: CLLocationDegrees = 0.01
        var lonDelta: CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
    }
    
    func addLocation(gestureRecognizer: UIGestureRecognizer){
        //executed once per long press
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            var touchPoint = gestureRecognizer.locationInView(self.map)
            var newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            var userLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
                if((error) != nil){
                    println("error:  \(error)")
                }else{
                    if let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark) {
                        var mainLocation = ""
                        var subLocation = ""
                    
                        if(p.thoroughfare != nil){
                            mainLocation = p.thoroughfare
                        }
                    
                        if(p.subThoroughfare != nil){
                            subLocation = p.subThoroughfare
                        }
                        title = "\(subLocation) \(mainLocation)"
                    }
                    
                    if title == "" {
                        title = "Added \(NSDate())"
                    }
                    
                    //places.append(["name": title, "lat": "\(newCoordinate.latitude)", "lon": "\(newCoordinate.longitude)"])
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    self.map.addAnnotation(annotation)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

