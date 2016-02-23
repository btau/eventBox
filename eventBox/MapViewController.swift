//
//  MapViewController.swift
//  eventBox
//
//  Created by Brett Tau on 2/22/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    var event: Event!
    
    var currentEvent = Event()
    var currentEventAnnotation = MGLPointAnnotation()
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.eventBoxBlack()
        
        // initialize the map view
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.showsUserLocation = true
        
        //TODO: Test Code - Delete Later
        currentEvent.eventName = "Test Event"
        currentEvent.location = LocationCords(lat: 41.8789, lon: -87.6358)
        
        //Creating Pin Annotation for Event
        currentEventAnnotation.coordinate = CLLocationCoordinate2DMake(currentEvent.location.lat, currentEvent.location.lon)
        mapView.setCenterCoordinate(CLLocationCoordinate2DMake(currentEvent.location.lat, currentEvent.location.lon), zoomLevel: 15, animated: false)
        currentEventAnnotation.title = currentEvent.eventName
        mapView.addAnnotation(currentEventAnnotation)
        view.addSubview(mapView)
        mapView.delegate = self

        //Reverse GeoCoding Lat/Lon to Event Address
        let location = CLLocation(latitude: currentEvent.location.lat, longitude: currentEvent.location.lon)
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) -> Void in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                return
            }
            if placemark!.count > 0 {
                let pm = placemark![0] as CLPlacemark
                if pm.subThoroughfare != nil && pm.thoroughfare != nil && pm.locality != nil && pm.administrativeArea != nil && pm.postalCode != nil {
                    self.eventAddressLabel.textColor = UIColor.whiteColor()
                    self.eventAddressLabel.text = "\(pm.subThoroughfare!) \(pm.thoroughfare!) \(pm.locality!), \(pm.administrativeArea!) \(pm.postalCode!)"
                }
            }
        }
     
        
        eventNameLabel.textColor = UIColor.eventBoxGreen()
        eventNameLabel.text = currentEvent.eventName
        
        
    }
    
    @IBAction func onGetDirectionsTapped(sender: UIButton) {
        //TODO: Send user to Apple Maps for step by step directions
    }
    
}
