//
//  MapViewController.swift
//  eventBox
//
//  Created by Brett Tau on 2/22/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import Mapbox
import MapKit
import CoreLocation

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    var locationManager = CLLocationManager()
//    var currentEvent = Event()
    var currentEventAnnotation = MGLPointAnnotation()
    var currentEvent: Event = NetworkManager.sharedManager.selectedEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "eventUpdate", object: nil)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.view.backgroundColor = UIColor.eventBoxBlack()
        getDirectionsButton.backgroundColor = UIColor.eventBoxAccent()
        getDirectionsButton.setTitleColor(UIColor.eventBoxBlack(), forState: .Normal)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    
    func reloadData() {
        currentEvent = NetworkManager.sharedManager.selectedEvent!
        eventNameLabel.textColor = UIColor.eventBoxAccent()
        eventNameLabel.text = currentEvent.eventName
        mapView.removeAnnotation(currentEventAnnotation)
        createPinAnnotation()
        reverseGeocode()
    }
    
    
    func createPinAnnotation() {
        currentEventAnnotation.coordinate = CLLocationCoordinate2DMake(currentEvent.location.lat, currentEvent.location.lon)
        mapView.setCenterCoordinate(CLLocationCoordinate2DMake(currentEvent.location.lat, currentEvent.location.lon), zoomLevel: 15, animated: false)
        currentEventAnnotation.title = currentEvent.eventName
        mapView.addAnnotation(currentEventAnnotation)
        view.addSubview(mapView)
    }
    
    
    func reverseGeocode() {
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
    }
    
    
    @IBAction func onGetDirectionsTapped(sender: UIButton) {
        
        let coords = CLLocationCoordinate2DMake(self.currentEvent.location.lat, self.currentEvent.location.lon)
        let placemark = MKPlacemark(coordinate: coords, addressDictionary: nil)
        let item = MKMapItem(placemark: placemark)
        item.name = self.currentEvent.eventName
        item.openInMapsWithLaunchOptions(nil)
        
        locationManager.stopUpdatingLocation()
    }
    
}
