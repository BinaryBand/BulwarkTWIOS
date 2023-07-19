//
//  CustomMapView.swift
//  BulwarkTW
//
//  Created by Shane Davenport on 7/18/23.
//

import UIKit
import MapKit

class CustomMapView: MKMapView {

    func addCustomLine() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 33.19376820, longitude: -111.57363810),
            CLLocationCoordinate2D(latitude: 33.19376690, longitude: -111.57372120),
            CLLocationCoordinate2D(latitude: 33.19367490, longitude: -111.57371920),
            CLLocationCoordinate2D(latitude: 33.19367380, longitude: -111.57379320),
            CLLocationCoordinate2D(latitude: 33.19357180, longitude: -111.57379090),
            CLLocationCoordinate2D(latitude: 33.19357430, longitude: -111.57363380),
            CLLocationCoordinate2D(latitude: 33.19376820, longitude: -111.57363810)
        ]
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        addOverlay(polyline)
    }
}


extension CustomMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 10.0
            renderer.strokeColor = UIColor.red
            return renderer
        }
        
        // Return a default renderer for other overlay types if needed
        return MKOverlayRenderer(overlay: overlay)
    }
}
