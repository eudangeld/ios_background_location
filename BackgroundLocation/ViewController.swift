//
//  ViewController.swift
//  BackgroundLocation
//
//  Created by dan on 14/08/19.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController ,CLLocationManagerDelegate {
    
    static let geoCoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    var locationStatus : NSString = "Not Started"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNotifications()
    }
    
    func initNotifications(){
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            self.initLocation()
        }
    }
    
    func initLocation(){
        print("init location")
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 2
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
       
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("location manager received")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Update location")
        let content = UNMutableNotificationContent()
        content.title = "Location detected 📌"
        content.body = "Locations descriptuon alert"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "location.dateString", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        
        
        print(status)
        
        if (shouldIAllow == true) {
            print("Location to Allowed startUpdatingLocation()")
           
            locationManager.startUpdatingLocation()
        } else {
            print("Denied access: \(locationStatus)")
        }
    }


}

