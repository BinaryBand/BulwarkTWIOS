//
//  TBSController.swift
//  BulwarkTW
//
//  Created by Shane Davenport on 7/13/23.
//

import UIKit
import MapKit
import CoreLocation

class TBSController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var appleMap: MKMapView!
    var overlayView: UIView!
    
    let geocoder = CLGeocoder()
    
    var accountId: String?
    var customerName: String?
    var address: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate of the MKMapView
        appleMap.delegate = self
        
        print("Account ID:", accountId!)
        print("Customer name:", customerName!)
        print("Address:", address!)
        
        setMapWithAddress(address: address!);
    }
    
    func setMapWithAddress(address: String) {
        
        convertAddressToCoordinates(address: address) { (coordinate, postalCode, error) in
            
            if let coordinate = coordinate {
                
                // Use the coordinate (latitude and longitude) here
                let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                print(coordinate)
                
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
                self.appleMap.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = self.customerName!
                self.appleMap.addAnnotation(annotation)
            }
            
            if let postalCode = postalCode {
                print("Postal Code: \(postalCode)")
            }
            
            if let error = error {
                // Handle error
                print("Geocoding error: \(error.localizedDescription)")
            }
        }
    }
    
    func convertAddressToCoordinates(address: String, completion: @escaping (CLLocationCoordinate2D?, String?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        print(address)
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            if let location = placemarks?.first?.location,
               let postalCode = placemarks?.first?.postalCode {
                print(postalCode)
                completion(location.coordinate, postalCode, nil)
            } else {
                completion(nil, nil, nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
