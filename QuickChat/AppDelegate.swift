//
//  AppDelegate.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/8/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var backendless = Backendless.sharedInstance()
    var locationManager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D?
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true //offline mode
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        self.LocationManagerStart()
    }

    func applicationWillTerminate(application: UIApplication) {
        self.LocationManagerStop()
    }

    
    //MARK: LocationManager Functions
    func LocationManagerStart()
    {
        if self.locationManager == nil
        {
            print ("init locationManager")
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.requestWhenInUseAuthorization()
        }
        
        print ("have locationManager")
        self.locationManager!.startUpdatingLocation()
        
    }
    func LocationManagerStop()
    {
        self.locationManager!.stopUpdatingLocation()
    }
    
    
    //MARK: clLocationManager Delegate Function
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.coordinate = locations.last!.coordinate
    }
    
    
}

