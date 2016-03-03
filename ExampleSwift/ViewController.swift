//
//  ViewController.swift
//  ExampleSwift
//
//  Created by Dave Hardiman on 03/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var apiKey: String {
        return NSBundle.mainBundle().URLForResource("APIKEY", withExtension: nil).flatMap { url -> String? in
            do { return try String(contentsOfURL: url) } catch { return nil }
            } ?? ""
    }

    @IBOutlet weak var mapView: MKMapView!
    
    

}

