//
//  BaitTrapController.swift
//  BulwarkTW
//
//  Created by Shane Davenport on 7/17/23.
//

import UIKit
import MapKit
import CoreLocation

class BugTrapAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var barcode: String?
    var date: Date?
    var image: String?
    var notes: String?
    
    init(coordinate: CLLocationCoordinate2D, barcode: String, date: Date, image: String) {
        self.coordinate = coordinate
        self.barcode = barcode
        self.date = date
        self.image = image
    }
}

class BaitTrapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var appleMap: CustomMapView!
    
    var hoveringImageView: UIImageView!
    
    var accountId: String?
    var customerName: String?
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleMap.delegate = self
        
        appleMap.isRotateEnabled = false
        appleMap.showsUserLocation = true
        appleMap.mapType = .satellite
        
        let range = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 25)
        appleMap.setCameraZoomRange(range, animated: true)
        
        let center = CLLocationCoordinate2D(latitude: 33.19376820, longitude: -111.57363810)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        appleMap.setRegion(region, animated: true)
        
        appleMap.addCustomLine()
        
        hoveringImageView = UIImageView(image: UIImage(named: "AppIcon"))
        hoveringImageView.center = appleMap.center
        appleMap.addSubview(hoveringImageView)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 5
            renderer.strokeColor = .red
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
        
//        let houseCoordinates = [
//            CLLocationCoordinate2D(latitude: 33.19376820, longitude: -111.57363810),
//            CLLocationCoordinate2D(latitude: 33.19376690, longitude: -111.57372120),
//            CLLocationCoordinate2D(latitude: 33.19367490, longitude: -111.57371920),
//            CLLocationCoordinate2D(latitude: 33.19367380, longitude: -111.57379320),
//            CLLocationCoordinate2D(latitude: 33.19357180, longitude: -111.57379090),
//            CLLocationCoordinate2D(latitude: 33.19357430, longitude: -111.57363380),
//            CLLocationCoordinate2D(latitude: 33.19376820, longitude: -111.57363810)
//        ]
//        
//        var temp = [MKPointAnnotation]()
//        for h in houseCoordinates {
//            let p = MKPointAnnotation()
//            p.coordinate = h
//            temp.append(p)
//            
//            appleMap.addAnnotation(p)
//        }
//        
//        let points = temp.map({ $0.coordinate })
//        
//        let polyline = MKPolyline(coordinates: points, count: points.count)
//        
//        appleMap.addOverlay(polyline)
//        
//        let center = CLLocationCoordinate2D(latitude: 33.19376820, longitude: -111.57363810)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
//        self.appleMap.setRegion(region, animated: true)
        
//        Coordinates: ()
//        Barcode: String
//        Picture: Blob
//        Result: List<String>
//        Placement Date
        
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address!) {
//            placemarks, error in
//            let placemark = placemarks?.first
////            let lat = placemark?.location?.coordinate.latitude
////            let lon = placemark?.location?.coordinate.longitude
//
//            let lat = 33.19376820
//            let lon = -111.57363810
//
//            let coords = [
//                (33.19376820, -111.57363810),
//                (33.19376690, -111.57372120),
//                (33.19367490, -111.57371920),
//                (33.19367380, -111.57379320),
//                (33.19357180, -111.57379090),
//                (33.19357430, -111.57363380),
//                (33.19376820, -111.57363810)
//            ]
//
//            for c in coords {
//                let marker = BuildingDotAnnotation(coordinate: CLLocationCoordinate2D(latitude: c.0, longitude: c.1))
//                self.appleMap.addAnnotation(marker)
//            }
//
////            let houseMarker = BuildingDotAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
////            houseMarker.title = "Lat: \(lat), Lon: \(lon)"
////            print(houseMarker.title)
////            self.appleMap.addAnnotation(houseMarker)
//
//        }
//
//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            print ("Here we are")
//            var center = mapView.centerCoordinate
//            print ("Center is \(center)")
//        }
        
//        // Create building dots annotations
//        let dot1 = BuildingDotAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
//        let dot2 = BuildingDotAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7743, longitude: -122.4199))
//
//        // Create bug trap annotations
//        let bugTrap1 = BugTrapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7735, longitude: -122.4183))
//        let bugTrap2 = BugTrapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7752, longitude: -122.4186))
//
//        // Add annotations to the map view
//        appleMap.addAnnotations([dot1, dot2, bugTrap1, bugTrap2])
//    }
    
    @IBAction func newTrapClick(_ sender: Any) {
        
//        let newTrap = MKPointAnnotation()
//        newTrap.coordinate = appleMap.centerCoordinate
//        appleMap.addAnnotation(newTrap)
        
//        let newStoryBoard = UIStoryboard(name: "NewTrapController", bundle: nil)
//        let newViewController = newStoryBoard.instantiateViewController(withIdentifier: "NewTrap_vc") as! NewTrapController
//        
//        newViewController.appleMap = appleMap
//        
//        self.navigationController?.present(newViewController, animated: true)
    }

}
