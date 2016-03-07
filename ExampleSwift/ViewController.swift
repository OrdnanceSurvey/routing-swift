//
//  ViewController.swift
//  ExampleSwift
//
//  Created by Dave Hardiman on 03/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import UIKit
import MapKit
import Routing
import CoreLocation

class ViewController: UIViewController {

    var apiKey: String {
        return NSBundle.mainBundle().URLForResource("APIKEY", withExtension: nil).flatMap { url -> String? in
            do { return try String(contentsOfURL: url) } catch { return nil }
            } ?? ""
    }

    @IBOutlet weak var mapView: MKMapView!

    var routingService: RoutingService!

    lazy var tappedPoints = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        routingService = RoutingService(apiKey: apiKey, vehicleType: .Car)
        mapView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: "mapTapped:")
        mapView.addGestureRecognizer(tap)
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = UIColor.redColor()
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension ViewController {
    func mapTapped(tap: UITapGestureRecognizer) {
        guard tap.state == .Ended else {
            return
        }
        let touchPoint = tap.locationInView(mapView)
        let touchCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)

        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = touchCoordinate
        mapView.addAnnotation(pointAnnotation)
        tappedPoints.append(touchCoordinate)
        updateRoute()
    }

    func updateRoute() {
        routingService.routeBetween(coordinates: tappedPoints) { result in
            switch result {
            case .Success(let route):
                self.displayRoute(route)
            case .Failure(let error):
                print("Routing failed \(error)")
            }
        }
    }

    func displayRoute(route: Route) {
        var locations = route.locations
        let line = MKPolyline(coordinates: &locations , count: locations.count)
        mapView.addOverlay(line)
    }
}

