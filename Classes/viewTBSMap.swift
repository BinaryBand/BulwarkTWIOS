//
//  viewTBSMap.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 6/29/23.
//

import UIKit
import MapKit

class viewTBSMap: UIViewController {

    @IBOutlet var map: MKMapView!
    
    var lat:Double = 0.0
    var lon:Double = 0.0
    
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        map.showsUserLocation = true
        map.showsScale = true
        map.showsCompass = true
        
        
        lat = 33.275740
        lon = -111.69565
        
        
        let oahuCenter = CLLocation(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(
              center: oahuCenter.coordinate,
              latitudinalMeters: 0,
              longitudinalMeters: 0)
        map.setCameraBoundary(
              MKMapView.CameraBoundary(coordinateRegion: region),
              animated: true)
            
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100)
            map.setCameraZoomRange(zoomRange, animated: true)
        // Do any additional setup after loading the view.
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
extension viewTBSMap : MKMapViewDelegate {
  //DELEGATE FUNCTIONS
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If you're showing the user's location on the map, don't set any view
        if annotation is MKUserLocation { return nil }
            
        
        guard let annotation = annotation as? TBSPointAnnotation else {
            return nil
        }
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
            
        
       
            view.annotation = annotation
        

         
        // Balloon Shape Pin (iOS 11 and above)
        
            // Customize only the 'Example 0' Pin
            if annotation.identifier == 1 {
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .cyan
                view.displayPriority = .required// Background color of the balloon shape pin
                //view.glyphImage = UIImage(systemName: "1.circe") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                view.glyphText = annotation.stopNumber.toString()  // Text instead of image
                view.glyphTintColor = .black // The color of the image if this is a icon
                return view
            }else if annotation.identifier == 2{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .darkGray
                view.displayPriority = .required// Background color of the balloon shape pin
                //view.glyphImage = UIImage(systemName: "2.circe") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .yellow // The color of the image if this is a icon
                return view
                
            }else if annotation.identifier == 3{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .lightGray
                view.displayPriority = .required// Background color of the balloon shape pin
                //view.glyphImage = UIImage(systemName: "2.circe") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .yellow // The color of the image if this is a icon
                return view
                
            }else if annotation.identifier == 4{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .green
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "house.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .black // The color of the image if this is a icon
                return view
                
            }else if annotation.identifier == 10{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .purple
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "star.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .yellow // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 11{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .purple
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "circle.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 12{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .magenta
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "star.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .yellow // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 13{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .magenta
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "circle.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 20{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "star.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .yellow // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 21{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "star.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 22{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "square.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .gray // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 23{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "square.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .red // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }
            else if annotation.identifier == 24{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "circle.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }else if annotation.identifier == 25{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "circle.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .blue // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }
            else if annotation.identifier == 29{
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = .orange
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "square.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                 //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
                
            }
        }
            

                    
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.setColors([
            .red,
            .purple,
            .blue
        ], locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 4.0
    return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      //let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "modalWeb") as! viewModalWeb
        
        
        if let atmPin = view.annotation as? MyPointAnnotation
        {
            let customView = self.storyboard?.instantiateViewController(withIdentifier: "modalWeb") as? viewModalWeb
            
            
            //let d = "For Tomorrows Route"
            
            customView?.hrEmpId = appDelegate.hrEmpId
            
            
            
            customView?.url = atmPin.proactiveAcct?.detailsUrl
            customView?.useCookie = false
            customView?.title = atmPin.proactiveAcct?.accountNumber
            
            customView?.modalTransitionStyle = .crossDissolve
            customView?.modalPresentationStyle = .pageSheet
            
            
            self.present(customView!,animated:true, completion:nil)
            
            
            
            
            /*
             
             if atmPin.identifier == 10{
             anotherViewController.hrEmpId = appDelegate.hrEmpId
             anotherViewController.url = atmPin.proactiveAcct?.detailsUrl
             anotherViewController.useCookie = false
             anotherViewController.title = atmPin.proactiveAcct?.accountNumber
             }
             if atmPin.identifier == 11{
             anotherViewController.hrEmpId = appDelegate.hrEmpId
             anotherViewController.url = atmPin.proactiveAcct?.detailsUrl
             anotherViewController.useCookie = false
             anotherViewController.title = atmPin.proactiveAcct?.accountNumber
             }
             if atmPin.identifier == 12{
             anotherViewController.hrEmpId = appDelegate.hrEmpId
             anotherViewController.url = atmPin.proactiveAcct?.detailsUrl
             anotherViewController.useCookie = false
             anotherViewController.title = atmPin.proactiveAcct?.accountNumber
             }
             if atmPin.identifier == 13{
             anotherViewController.hrEmpId = appDelegate.hrEmpId
             anotherViewController.url = atmPin.proactiveAcct?.detailsUrl
             anotherViewController.useCookie = false
             anotherViewController.title = atmPin.proactiveAcct?.accountNumber
             }
             //anotherViewController.currentAtmPin = atmPin
             
             
             }
             self.navigationController?.pushViewController(anotherViewController, animated: true)
             */
        }
    }
    
    
}

class TBSPointAnnotation : MKPointAnnotation {
    var identifier: Int?
    var stopNumber: Int = 0
    var proactiveAcct :ProactiveAccount?
}

