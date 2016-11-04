//
//  MapViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 11/5/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var MAP: MKMapView!
    
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var region = MKCoordinateRegion()
        region.center.latitude = self.location.coordinate.latitude
        region.center.longitude = self.location.coordinate.longitude
        region.span.latitudeDelta = 0.1
        region.span.longitudeDelta = 0.1
        self.MAP.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        self.MAP.addAnnotation(annotation)
        annotation.coordinate = self.location.coordinate
        
        
    }

    @IBAction func BTN_Cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
