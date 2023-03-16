//
//  viewMap.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/27/23.
//

import UIKit
import MapKit

class viewMap: UIViewController {
    
    @IBOutlet var map: MKMapView!
    
    var mapStops: [MapStop] = []
    var routeOverlay : MKOverlay?
    var routeCoordinates : [CLLocation] = []
    var homegps: SPHomeGps?
    var proactivList:[ProactiveAccount] =  []
    var cancelList:[ProactiveAccount] =  []
    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    @IBOutlet var tglProactive: UIBarButtonItem!
    
    
    var proIsOn: Bool = false
    var canIsOn: Bool = false
    var recIsOn: Bool = false
    var hybridIsOn: Bool = false
    
    
    @IBOutlet var proactiveswitch: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = true
        
       // #if targetEnvironment(simulator)
       // map.showsTraffic = false
       // #endif
        
        self.map.showAnnotations(self.map.annotations, animated: true)
        
        viewMapToggles.delegate = self
        //let annotation1 = MyPointAnnotation()
        //annotation1.coordinate = CLLocationCoordinate2D(latitude: 33.95, longitude: -117.34)
        //annotation1.title = "Example 0" // Optional
        //annotation1.subtitle = "Example 0 subtitle" // Optional
        //annotation1.identifier = 1
        //self.map.addAnnotation(annotation1)
        map.showsScale = true
        map.showsCompass = true
        //map.mapType = .hybrid
        map.pointOfInterestFilter = .init(including: [.airport,.bank,.gasStation,.hospital,.atm,.restroom,.store,.foodMarket,.restaurant])
        self.setViewBox()
        //self.setRouteLines()


        Utilities.delay(bySeconds: 0.5, dispatchLevel: .background){
            self.addPins()
            
        }
       
        // Do any additional setup after loading the view.
    }
    
    func setViewBox() {
        if mapStops.count != 0  {
            
            
           
            
            for m in mapStops {
                
               
                
                
                
                let cord2 = CLLocation(
                    latitude: m.lat,
                    longitude: m.lon
                )
             
                routeCoordinates.append(cord2)
                
                
                
                
                
            }
            let coordinates = routeCoordinates.map { location -> CLLocationCoordinate2D in
                        return location.coordinate
                    }
            self.routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            
            let customEdgePadding : UIEdgeInsets = UIEdgeInsets(
                top: 20,
                left: 20,
                bottom: 20,
                right: 20
            )
            self.map.setVisibleMapRect(self.routeOverlay!.boundingMapRect, edgePadding: customEdgePadding,animated: true)
            
            
            
            
            
        }
    }
    
    
   

    
    
    func addProactivePins(){
        if proactivList.count > 0{
            
               
            for p in proactivList {
                let lat = p.lat ?? 0
                let lon = p.lon ?? 0
                
                let coord = CLLocationCoordinate2D(latitude:lat, longitude: lon)
                
                let pin = MyPointAnnotation()
                pin.title = p.address
                
                
                
                var tid = 10;
                
                if p.typeId == 1{
                    //31 Dormant
                    tid = 10;
                    pin.subtitle = "31 Dormant"
                    
                }
                
                if p.typeId == 2{
                    // 31 Proactive
                    tid = 11;
                    pin.subtitle = "31 Proactive"
                    
                }
                if p.typeId == 3{
                    // RR Extra
                    tid = 12;
                    pin.subtitle = "Rolling Dormant"
                    
                }
                if p.typeId == 4{
                    // RR Going Dormant
                    tid = 13;
                    pin.subtitle = "Rolling Proactive"
                    
                }
                
                
                
                pin.identifier = tid
                
                
                pin.stopNumber = 0
                pin.coordinate = coord
                pin.proactiveAcct = p
                
                Utilities.delay(bySeconds: 0.1, dispatchLevel: .main){
                    self.map.addAnnotation(pin)
                    
                }  
            }
        }
    }
    
    func removeProactivePins(){
        
        let anno = map.annotations
        
        for a in anno{
            if let p = a as? MyPointAnnotation{
                
                if p.identifier == 10 {
                    
                    map.removeAnnotation(a)
                    
                    
                }
                if p.identifier == 11 {
                    
                    map.removeAnnotation(a)
                    
                    
                }
                if p.identifier == 12 {
                    
                    map.removeAnnotation(a)
                    
                    
                }
                if p.identifier == 13 {
                    
                    map.removeAnnotation(a)
                    
                    
                }
            }
            
            
            
            
            
        }
    }
    
    
    func addCancelPins(isMoved:Bool){
        if cancelList.count > 0{
            
               
            for p in cancelList {
                let lat = p.lat ?? 0
                let lon = p.lon ?? 0
                
                let coord = CLLocationCoordinate2D(latitude:lat, longitude: lon)
                
                let pin = MyPointAnnotation()
                pin.title = p.address
                
                
                
                var tid = 29;
                
                let rct = p.status ?? "Recent Cancel"
                
                let rctl = rct.lowercased()
                if rctl.starts(with: "move"){
                    tid = 20
                    
                }
                if rctl.starts(with: "one"){
                    tid = 21
                    
                }
                if rctl.starts(with: "do it"){
                    tid = 21
                    
                }
                if rctl.starts(with: "dis"){
                    tid = 22
                    
                }
                if rctl.starts(with: "coll"){
                    tid = 23
                    
                }
                if rctl.starts(with: "fina"){
                    tid = 24
                    
                }
                if rctl.starts(with: "switch"){
                    tid = 25
                    
                }
                if rctl.starts(with: "do not"){
                    tid = 23
                    
                }
                
                pin.subtitle = rct
                
                
             
                                             
                               
                
                
                pin.identifier = tid
                
                
                pin.stopNumber = 0
                pin.coordinate = coord
                pin.proactiveAcct = p
                if isMoved {
                    if tid == 20{
                        Utilities.delay(bySeconds: 0.1, dispatchLevel: .main){
                            self.map.addAnnotation(pin)
                            
                        }
                    }
                }else{
                    if tid != 20{
                        Utilities.delay(bySeconds: 0.1, dispatchLevel: .main){
                            self.map.addAnnotation(pin)
                            
                        }
                    }
                    
                }
                
            }
        }
    }
    
    func removeCancelPins(){
        
        let anno = map.annotations
        
        for a in anno{
            if let p = a as? MyPointAnnotation{
                
                let pid = p.identifier ?? 0
                if pid >= 21 && pid < 30 {
                    
                    map.removeAnnotation(a)
                    
                    
                }
                
            }
            
            
            
            
            
        }
    }
    func removeMovedPins(){
        
        let anno = map.annotations
        
        for a in anno{
            if let p = a as? MyPointAnnotation{
                
                let pid = p.identifier ?? 0
                if pid == 20 {
                    
                    map.removeAnnotation(a)
                    
                    
                }
                
            }
            
            
            
            
            
        }
    }
    
    func addPins() {
            if mapStops.count != 0  {
                
                var stpnum = 1
                
                
                let hlat = homegps?.lat ?? 0
                let hlon = homegps?.lon ?? 0
                
                var lastcoord = CLLocationCoordinate2D(
                    latitude: 0,
                    longitude: 0
                )
                
                if hlat != 0{
                    lastcoord.latitude = hlat
                    lastcoord.longitude = hlon
                    
                    let pin = MyPointAnnotation()
                    pin.title = homegps?.address
                    pin.subtitle = ""
                    pin.identifier = 4
                    pin.stopNumber = 0
                    pin.coordinate = lastcoord
                    
                    Utilities.delay(bySeconds: 0.1, dispatchLevel: .main){
                        self.map.addAnnotation(pin)
                        
                    }
                    
                    
                }
                
                
                for m in mapStops {
                    
                    let pin = MyPointAnnotation()
                    pin.title = m.title
                    pin.subtitle = m.subtitle
                    pin.identifier = m.colorId
                    
                    
                    let cord = CLLocationCoordinate2D(
                        latitude: m.lat,
                        longitude: m.lon
                    )
                    
                    let cord2 = CLLocation(
                        latitude: m.lat,
                        longitude: m.lon
                    )
                    pin.coordinate = cord
                    pin.stopNumber = stpnum
                    stpnum += 1
                    
                    routeCoordinates.append(cord2)
                    if lastcoord.latitude != 0.0 {
                        
                        let directionsRequest = MKDirections.Request()
                                                    directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: lastcoord))
                                                    directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: cord))
                                                    directionsRequest.requestsAlternateRoutes = true
                                                
                        directionsRequest.transportType = .automobile
                                                    let directions = MKDirections(request: directionsRequest)
                                                    
                                                    directions.calculate { response, error in
                                                        if let res = response {
                                                            if let route = res.routes.first {
                                                                self.map.addOverlay(route.polyline)
                                                                //self.map.region.center = cord
                                                                self.map.addAnnotation(pin)
                                                            }
                                                        } else {
                                                            print("error")
                                                        }
                                                    }
                        
                        
                        
                        
                        
                    }
                    
                    lastcoord = cord
                    Thread.sleep(forTimeInterval: 0.2)
                    //Utilities.delay(bySeconds: 0.05, dispatchLevel: .main) {
                        
                    
                    
                    
                    
                    
                       
                        
                   // }
                    
                    
                    
                }
                
        
                
                
                if hlat != 0 {
                    let hcoord = CLLocationCoordinate2D(latitude: hlat, longitude: hlon)
                    
                    if lastcoord.latitude != 0.0 {
                        
                        let directionsRequest = MKDirections.Request()
                        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: lastcoord))
                        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: hcoord))
                        directionsRequest.requestsAlternateRoutes = true
                        
                        directionsRequest.transportType = .automobile
                        let directions = MKDirections(request: directionsRequest)
                        
                        directions.calculate { response, error in
                            if let res = response {
                                if let route = res.routes.first {
                                    self.map.addOverlay(route.polyline)
                                    //self.map.region.center = cord
                                    //self.map.addAnnotation(pin)
                                }
                            } else {
                                print("error")
                            }
                        }
                        
                        
                        
                        
                        
                    }
                }
                
             

            }
        }
        
    func drawRoute(routeData: [CLLocation]) {
            if mapStops.count == 0 {
                print("No Coordinates to draw")
                return
            }
            
        let coordinates = routeData.map { location -> CLLocationCoordinate2D in
                    return location.coordinate
                }
        
            DispatchQueue.main.async {
                self.routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
                self.map.addOverlay(self.routeOverlay!, level: .aboveRoads)
                let customEdgePadding : UIEdgeInsets = UIEdgeInsets(
                    top: 50,
                    left: 50,
                    bottom: 50,
                    right: 50
                )
                self.map.setVisibleMapRect(self.routeOverlay!.boundingMapRect, edgePadding: customEdgePadding,animated: true)
            }
        }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
         
         
         //viewMapToggles
         
         if segue.identifier == "viewMapToggles" {
             
             

             
                 let dc = segue.destination as! viewMapToggles
                 dc.proIsOn = proIsOn
                 dc.canIsOn = canIsOn
                 dc.recIsOn = recIsOn
                 dc.hybridIsOn  = hybridIsOn
             
         }
         
     }
     
    
    
   
}
extension viewMap : MKMapViewDelegate {
  //DELEGATE FUNCTIONS
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If you're showing the user's location on the map, don't set any view
        if annotation is MKUserLocation { return nil }
            
        
        guard let annotation = annotation as? MyPointAnnotation else {
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
extension viewMap : MapToggleDelegate {
    func toggleProactive(isOn: Bool) {
        if isOn == true{
            addProactivePins()
            
            
        }else{
            
            removeProactivePins()
        }
        
        proIsOn = isOn
        
    }
    
    func toggleCancels(isOn: Bool) {
    canIsOn = isOn
        
        if isOn == true{
            addCancelPins(isMoved: true)
            
            
        }else{
            
            removeMovedPins()
            
        }
        
        
        
        
    }
    
    func toggleCancelRequests(isOn: Bool) {
        recIsOn = isOn
        if isOn == true{
            addCancelPins(isMoved: false)
            
            
        }else{
            
            removeCancelPins()
            
        }
        
    }
    
    func toggleMapType(isOn: Bool) {
        hybridIsOn = isOn
        
        if isOn{
            map.mapType = .hybrid
        }else{
            map.mapType = .standard
        }
        
    }
    
    
    
    
    
}
class MyPointAnnotation : MKPointAnnotation {
    var identifier: Int?
    var stopNumber: Int = 0
    var proactiveAcct :ProactiveAccount?
}

