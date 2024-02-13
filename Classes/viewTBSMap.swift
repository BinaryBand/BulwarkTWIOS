//
//  viewTBSMap.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 6/29/23.
//

import UIKit
import MapKit

class viewTBSMap: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var map: MKMapView!
    
    
    var routeStop:RouteStop!

    var appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
    
    var currentStationNumber:Int = 0
    
    var lastLat:Double = 0
    var lastLon:Double = 0
    
    
    var homePoly = [MKPolygon?]()
    var tmpPolyLine = [baitPolyLine?]()
    
    var annotations = [[TBSPointAnnotation]]()
    var annotationsPoly = [[TBSPointAnnotation]]()
    var baitStations = [StationCheck]()
    
    var stage:Int = 1
    var tap:UILongPressGestureRecognizer!
    
    @IBOutlet var lblCurrentStage: UILabel!
    
    @IBOutlet var btnNextStep: UIButton!
    
    @IBOutlet var lblDetails: UILabel!
    
 
    @IBOutlet var mapTop: NSLayoutConstraint!
    
    @IBOutlet var lblLinnearFt: UILabel!
    

    
    var polygonNumber:Int = 0
    var firstPolygonCoord:TBSPointAnnotation!
    var finishPoly:Bool = false
    
    var baitpolys:baitPolyLine?
    
    var selectedTBS:viewStationCheck?
    
    var fpPoints:[[GpsPoint]?]?
    
    
    var myLocIsOn: Bool = false
    var wallLengthIsOn: Bool = false
    var StationDistanceIsOn: Bool = false
    var footprintNeedsVerified: Bool = true
    
    var additionalConditions:[TermiteCondition]?
    
    var trenchPolys:[baitPolyLine]?
    var isNew:Bool?
    
    var ttlLiquidLF:Double?
    var homeLF:Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if trenchPolys == nil{
            trenchPolys = [baitPolyLine]()
        }
        //let cid = routeStop.customerId
        
        viewStationCheck.delegate = self
        viewTBSMapPopover.delegate = self
        
        map.delegate = self
        map.userTrackingMode = .followWithHeading
        map.showsUserLocation = false
        map.showsScale = true
        //map.showsCompass = tru
       
        map.mapType = .satellite
        
        
        lblDetails.isHidden = false
        
        let oahuCenter = CLLocation(latitude: routeStop.lat, longitude: routeStop.lon)
            let region = MKCoordinateRegion(
              center: oahuCenter.coordinate,
              latitudinalMeters: 50,
              longitudinalMeters: 50)
       // map.setCameraBoundary(
       //      MKMapView.CameraBoundary(coordinateRegion: region),
       //       animated: true)
        
        map.setRegion(region, animated: false)
        
           // let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 50)
           // map.setCameraZoomRange(zoomRange, animated: true)
        
        map.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10)
        
        //map.setValue(21, forKeyPath: "_map._mapCameraController._mapModel._forcedMaxZoomLevel")
        tap = UILongPressGestureRecognizer(target: self, action:#selector(self.handleTap))
        
        //tap.delaysTouchesBegan = true
        tap.delegate = self
        //tap.numberOfTapsRequired = 2
        //let lpgr = UILongPressGestureRecognizer
        tap.minimumPressDuration = 0.25
        //lpgr.delaysTouchesBegan = true
        //lpgr.delegate = self
        tap.isEnabled = false
        self.map.addGestureRecognizer(tap)
        let tmpanno = TBSPointAnnotation()
        tmpanno.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0);
        tmpanno.identifier = 99999
        firstPolygonCoord = tmpanno
        annotations.append([TBSPointAnnotation]())
        annotationsPoly.append([TBSPointAnnotation]())
        homePoly.append(nil)
        tmpPolyLine.append(nil)
        //homePoly[polygonNumber] = nil
        //tmpPolyLine[polygonNumber] = nil
        baitpolys = nil
        
        StationDistanceIsOn = true
       
        //getFootPrint()
        
        if additionalConditions == nil{
            additionalConditions = [TermiteCondition]()
        }
        
        
        if let savedStationData = DataUtilities.getTBSListFromFile(workOrderId: routeStop.workorder_id){
            if let n = savedStationData.isNew{
                isNew = n
            }
            
            if let verifyFP = savedStationData.footPrintNeedsVerified{
                footprintNeedsVerified = verifyFP
            }
            
            if let bs = savedStationData.stations{
                
                if bs.count >= baitStations.count{
                    baitStations = bs
                    
                }
                
            }
            if let ad = savedStationData.additionalConditions{
                if let cac = additionalConditions {
                    if ad.count >= cac.count{
                        additionalConditions = ad
                    }
                }
            }
            
            var found = false
            if let fp = savedStationData.footPrint{
                
                
                for f in fp{
                    if let ff = f {
                        if ff.count > 2 {
                            found = true
                        }
                    }
                }
                if found {
                    fpPoints = fp
                }
          
            }
            
            if found {
                
                drawFootPrint(fp: fpPoints!)
            }else{
                getFootPrint()
                
            }
            
            
        }
        
        currentStationNumber = baitStations.count
        
        updateStationMarkerColor()
        addMarkersForConditions()
        

        

        
        if let n = isNew {
            if baitStations.count > 5{
                isNew = false
            }else{
                isNew = true
            }
        }
        
        if footprintNeedsVerified {
            stage = 1
            nextStep(false)
        }else{
            stage = 4
            nextStep(false)
        }
        
       // Utilities.delay(bySeconds: 2.0, dispatchLevel: .main, closure: {
            
        //    self.map.setUserTrackingMode(.followWithHeading, animated: true)
            
            
       // })
        
    }
    
    func getFootPrint(){
        
        
            Task{
                
                do{
                    
                    let h = appDelegate.hrEmpId ?? "123456"
                    
                    let fp = try await JsonFetcher.fetchHomeFootPrint(workorderid: self.routeStop.workorder_id, hrEmpId: h)
                    
                    let s = StationHomeData(footPrint: fp, stations: baitStations, additionalConditions: additionalConditions, footPrintNeedsVerified: footprintNeedsVerified)
                    
                    DataUtilities.saveTBSCheckData(tbsList: s, workOrderId: routeStop.workorder_id)
                    fpPoints = fp
                       drawFootPrint(fp: fp)
                        
                    
                    
                }catch{
                    print(error)
                }
                
            }
            
            
            
        
        
        
        
        
        
        
        
    }
    
    
    func drawFootPrint(fp: [[GpsPoint]?] ){
        
        var foundFP = false
     
        for f in fp {
            if f!.count > 2 {
            
                var firstlat = 0.0
                var firstlon = 0.0
                
                for gps in f!{
                    
                    
                    let pin = TBSPointAnnotation();
                    pin.title = "Delete?"
                    
                   
                        pin.identifier = 2
                    
                        pin.polyNumber = polygonNumber
                    let pt = CLLocationCoordinate2D(latitude: gps.lat, longitude: gps.lon)
                    
                 
                    
                    pin.coordinate = pt
                      
                    if gps.lat != firstlat && gps.lon != firstlon{
                        map.addAnnotation(pin)
                        annotations[polygonNumber].append(pin)
                    }
                        //addTempAnnotationsForPoly(polygonNumber)
                    //coords.append(touchMapCoordinate)
                    if firstlat == 0{
                        firstlat = gps.lat
                        firstlon = gps.lon
                    }
                    
                        
                    //map.deselectAnnotation(pin, animated: false)
                    
                    foundFP = true
                    
                    
                    
                    
                    
                }
                
                finishPoly = true
                
                drawPolylineOrPolygon(pgNum: polygonNumber)
                annotations.append([TBSPointAnnotation]())
                
                annotationsPoly.append([TBSPointAnnotation]())
                
                homePoly.append(nil)
                tmpPolyLine.append(nil)
                polygonNumber = polygonNumber + 1
                
                
                
                
                
            }
                                    
        }
        
        
        Utilities.delay(bySeconds: 0.3, dispatchLevel: .main ,closure: {
            
            let anno = self.map.annotations
            
            for a in anno{
                if let p = a as? TBSPointAnnotation{
                    
                    let av = self.map.view(for: p)
                    av?.setSelected(false, animated: true)
                    //map.deselectAnnotation(p, animated: false)
                    
                }
            }
            if foundFP{
                if self.footprintNeedsVerified{
                    self.stage = 1
                    self.nextStep(true)
                }
            }
            
        })
        
    }
    


    func addMarkersForConditions(){
        
        if let ac = additionalConditions{
            for c in ac{
                
                
                let coordinate =  CLLocationCoordinate2D(latitude: c.lat, longitude: c.lon)
                
                let pinid = c.markerId
                
                let pin = TBSPointAnnotation();
                pin.title = "Delete"
                pin.stationNumber = 0
                //let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon);
                pin.identifier = c.typeId
                pin.polyNumber = 0
                pin.stationId = pinid
                pin.coordinate = coordinate
                map.addAnnotation(pin)
                

               
            }
        }
        
        
        distTrench()
        
        
        
        
    }
    
 
    
    @IBAction func btnAddStation(_ sender: Any) {
       
        
        getFootPrint()
        
        /*
        currentStationNumber = currentStationNumber + 1
        let pin = TBSPointAnnotation();
        pin.title = "TBS" + currentStationNumber.toString()
        pin.stationNumber = currentStationNumber
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon);
        pin.identifier = 1
        pin.coordinate = coord
        map.addAnnotation(pin)
        var ns = StationCheck(serviceId: serviceId, barcode: "", result: "", photoBase64: "", lat: coord.latitude, lon: coord.longitude, timeChecked: 0, stationNumber: currentStationNumber, isNew: true)
        
        baitStations.append(ns)
        */
        
        
    }
    
    func addConditionstoMapManually(typeId:Int){
       stage = typeId
        if typeId == 91{
            
           
            lblCurrentStage.text = "Add Termite Damage"
            lblDetails.text = "Long press on map then drag to adjust location"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
        if typeId == 92{
            
            
            lblCurrentStage.text = "Add Conditions Conducive"
            lblDetails.text = "Long press on map then drag to adjust location"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
        if typeId == 93{
            
          
            lblCurrentStage.text = "Add Active Subterranean Termites Location"
            lblDetails.text = "Long press on map then drag to adjust location"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
        if typeId == 94{
            
        
            lblCurrentStage.text = "Add Termite Mud Tubes"
            lblDetails.text = "Long press on map then drag to adjust location"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
        if typeId == 95{
            
            lblCurrentStage.text = "Add Signs Of Previous Infestation"
            lblDetails.text = "Long press on map then drag to adjust location"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
        if typeId == 96{
            
            lblCurrentStage.text = "Add Area to Trench"
            lblDetails.text = "Place markers to trench between"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
        if typeId == 97{
            
            lblCurrentStage.text = "Add Area to Drill"
            lblDetails.text = "Place markers to drill between"
            tap.isEnabled = true
            setNextStepTitle(title: "Finish")
            
            
            
            
        }
    }
    
    func nextStep(_ fromAutoFoot:Bool){
        if stage == 1{
            lblDetails.isHidden = false
            btnNextStep.isEnabled = true
           // if fromAutoFoot{
                lblCurrentStage.text = "Add/Verify and Edit Home Foot Print"
                lblDetails.text = "Drag circle/square markers to adjust foot print long press another area to add additional structures"
            //}
            //draw home foot print
            drawHome()
            stage = 2
        }else if stage == 2{
            //finish drawing foot Print
            finishDrawing()
            stage = 4
            
        }else if stage == 3 {
            //add stations
            //addStations()
            stage = 4
        }else if stage == 4{
            //finish adding
            
            checkStations()
            stage = 5
        }else if stage == 5{
            
            mapTop.constant = 300
            self.view.layoutIfNeeded()
            map.fitAllAnnotations()
            StationDistanceIsOn = false
            wallLengthIsOn = false
            footprintNeedsVerified = false
            drawPolylineOrPolygon(pgNum: polygonNumber)
            
            distBetweenStations()
            
            let tiles = MKTileOverlay(urlTemplate: nil)
            tiles.canReplaceMapContent = true
self.map.insertOverlay(tiles, at: 0)

Utilities.delay(bySeconds: 0.5, dispatchLevel: .main, closure: {
    self.performSegue(withIdentifier: "showTermiteCheckResults", sender: nil)
    self.map.removeOverlay(tiles)
    self.mapTop.constant = 0
    self.view.layoutIfNeeded()
})
            
            
            
        }else if stage > 90{
            stage = 4
            nextStep(false)
        }
    }
    @IBAction func btnNextStep(_ sender: Any) {

        nextStep(false)
    }
    
    
    func drawHome(){
        
        tap.isEnabled = true
        setNextStepTitle(title: "Finish")
        //display message box with instructions
        
        
        
        
    }
    
    func finishDrawing(){
        //tap.isEnabled = false
        /*
        let anno = map.annotations
        
        for a in anno{
            if let p = a as? TBSPointAnnotation{
                if p.identifier == 2 {
                    //p.identifier = 20
                   // coords.append(p.coordinate)
                    map.removeAnnotation(p)
                }
                
            }
            

            
        }
        
        */
        //mapTop.constant = 300
        footprintNeedsVerified = false
        drawPolylineOrPolygon(pgNum: polygonNumber)
        setNextStepTitle(title: "Finish")
        lblCurrentStage.text = "Add Bait Stations"
       // lblDetails.isHidden = true
        
        Utilities.delay(bySeconds: 0.2, dispatchLevel: .main ,closure: {
            self.nextStep(false)
            
        })
        
    }
    

    func checkStations(){
        
        tap.isEnabled = true
        setNextStepTitle(title: "Finish")
        if isNew ?? true{
            lblCurrentStage.text = "Add Then Check Each Bait Stations"
            lblDetails.text = "Long press to place station, hold and drag to move to exact location, select other conditions from menu, tap the station to enter station resultstrue"
        }else{
            lblCurrentStage.text = "Check Each Bait Stations"
            lblDetails.text = "Click each station to scan barcode and enter results"
        }
        
        
        btnNextStep.isEnabled = false
        stage = 5
        updateStationMarkerColor()
        
    }
    
    
    func setNextStepTitle(title: String){
        btnNextStep.setTitle(title, for: .focused)
        btnNextStep.setTitle(title, for: .application)
        btnNextStep.setTitle(title, for: .disabled)
        btnNextStep.setTitle(title, for: .highlighted)
        btnNextStep.setTitle(title, for: .normal)
        btnNextStep.setTitle(title, for: .selected)
        btnNextStep.setTitle(title, for: .reserved)
    }
    
    func updateStationMarkerColor(){
        //first remove all stations then readd them back in based on the baitstation list
        let anno = map.annotations
        var allHaveBeenChecked = true
        for a in anno{
            if let p = a as? TBSPointAnnotation{
                if p.identifier == 1 {
                    
                   // coords.append(p.coordinate)
                    map.removeAnnotation(p)
                }
                if p.identifier == 10 {
                    
                   // coords.append(p.coordinate)
                    map.removeAnnotation(p)
                }
                
            }
        }
        
       
        for bs in baitStations{
            //validate if has key info
            
            let res = bs.result
            let tm = bs.timeChecked
            let bc = bs.barcode
            let ph = bs.photoBase64
            let isnew = bs.isNew
            
            
            let pin = TBSPointAnnotation()
            pin.title = "TBS" + bs.stationNumber.toString()
            pin.stationNumber = bs.stationNumber
            let coord = CLLocationCoordinate2D(latitude: bs.lat, longitude: bs.lon);
            pin.identifier = 10
            pin.polyNumber = -1
            pin.coordinate = coord
            
            if res == ""{
                pin.identifier = 1
                allHaveBeenChecked = false
            }
            if tm == 0{
                pin.identifier = 1
                allHaveBeenChecked = false
            }
            if bc == "" {
                pin.identifier = 1
                allHaveBeenChecked = false
            }
            if ph == "" {
                var photoRequired = false
                if isnew {
                    photoRequired = true
                }
                if res == "Replaced 1 Bait Cartrage"{
                    photoRequired = true
                }
                if res == "Replaced 2 Bait Cartrages"{
                    photoRequired = true
                }
                
                if photoRequired{
                    pin.identifier = 1
                    allHaveBeenChecked = false
                }
                
            }
            map.addAnnotation(pin)
            
            if allHaveBeenChecked{
                if stage == 5{
                    btnNextStep.isEnabled = true
                }
            }else{
                if stage == 5{
                    btnNextStep.isEnabled = false
                }
            }
        }
        
        
        let sv = StationHomeData(footPrint: fpPoints, stations: baitStations, additionalConditions: additionalConditions, footPrintNeedsVerified: footprintNeedsVerified)
        DataUtilities.saveTBSCheckData(tbsList: sv, workOrderId: routeStop.workorder_id)
      
        
        
        
    }
    
    
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state != UIGestureRecognizer.State.ended {
                return
            }
        else if gestureRecognizer.state != UIGestureRecognizer.State.began {
            if stage == 2{
                
                let anno = map.annotations
                
                for a in anno{
                    if let p = a as? TBSPointAnnotation{
                        
                        let av = map.view(for: p)
                        av?.setSelected(false, animated: true)
                        //map.deselectAnnotation(p, animated: false)
                        
                    }
                }
                
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            let touchMapCoordinate =  self.map.convert(touchPoint, toCoordinateFrom: map)
            
            let pin = TBSPointAnnotation();
            pin.title = "Delete?"
            
           
                pin.identifier = 2
            
                pin.polyNumber = polygonNumber
            
            pin.coordinate = touchMapCoordinate
                
            map.addAnnotation(pin)
            annotations[polygonNumber].append(pin)
                //addTempAnnotationsForPoly(polygonNumber)
            //coords.append(touchMapCoordinate)
           
                drawPolylineOrPolygon(pgNum: polygonNumber)
           
            lastLat = touchMapCoordinate.latitude
            lastLon = touchMapCoordinate.longitude
            
            }
            
            if stage==4 || stage == 5{
               
                let touchPoint = gestureRecognizer.location(in: self.map)
                
                let touchMapCoordinate =  self.map.convert(touchPoint, toCoordinateFrom: map)
                
                currentStationNumber = currentStationNumber + 1
                let pin = TBSPointAnnotation();
                pin.title = "TBS" + currentStationNumber.toString()
                pin.stationNumber = currentStationNumber
                //let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon);
                pin.identifier = 1
                pin.polyNumber = 0
                pin.coordinate = touchMapCoordinate
                map.addAnnotation(pin)
                let ns = StationCheck(workOrderItemId: routeStop.workorderitem_id, barcode: "", result: "", photoBase64: "", lat: touchMapCoordinate.latitude, lon: touchMapCoordinate.longitude, timeChecked: 0, stationNumber: currentStationNumber, isNew: true, id: 0)
                
                baitStations.append(ns)
                distBetweenStations()
            }
            
            
            
            if stage >= 91 && stage < 100{
                //termite damage
                
                
                let touchPoint = gestureRecognizer.location(in: self.map)
                
                let touchMapCoordinate =  self.map.convert(touchPoint, toCoordinateFrom: map)
                
                let pinid = UUID().uuidString
                
                let pin = TBSPointAnnotation();
                pin.title = "Delete"
                pin.stationNumber = 0
                //let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon);
                pin.identifier = stage
                pin.polyNumber = 0
                pin.stationId = pinid
                pin.coordinate = touchMapCoordinate
                map.addAnnotation(pin)
                
                let ns = TermiteCondition(typeId: stage, lat: touchMapCoordinate.latitude, lon: touchMapCoordinate.longitude,markerId: pinid)
                
                additionalConditions?.append(ns)
                distTrench()
            }
            
            
            
            
        }
        }
    
    func drawPolylineOrPolygon(pgNum: Int){
        
        let anno = map.annotations
            
            
            //let overlays = map.overlays
            //for o in overlays{
            //    if o is MKPolyline{
            //
            //        map.removeOverlay(o)
            //
            //    }
            //   if o is MKPolygon{
            //      map.removeOverlay(o)
            //  }
            // }
            
        
        

        
            if let ppll = tmpPolyLine[pgNum]{
                map.removeOverlay(ppll)
                tmpPolyLine[pgNum] = nil
            }
            if let pgn = homePoly[pgNum]{
                map.removeOverlay(pgn)
                homePoly[pgNum] = nil
            }
            
            
        
        
        
        
            
            for a in anno{
                if let p = a as? TBSPointAnnotation{
                    if p.identifier == 3 || p.identifier == 20 || p.identifier == 2{
                        
                        // coords.append(p.coordinate)
                        map.removeAnnotation(p)
                    }
                    
                }
                
                
                
            }
        
        let fpv = footprintNeedsVerified
        
        
        
        
        if footprintNeedsVerified {

                for polys in annotations{
                    for corner in polys{
                        map.addAnnotation(corner)
                    }
            }
            
        }
        
        
        var ttlLF = 0.0;
        addTempAnnotationsForPoly(pgNum)
        var avgLat = 0.0
        var avglon = 0.0
        var countLL = 0.0
        for alist in annotationsPoly{
           
                let coordsCp = alist
                var lcoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                var firstcoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                var cntNumber = 0
                for c in coordsCp {
                    if c.identifier == 2{
                        if lcoord.latitude != 0{
                            
                            let tlat = (lcoord.latitude + c.coordinate.latitude) / 2
                            let tlon = (lcoord.longitude + c.coordinate.longitude) / 2
                            
                            avgLat += tlat
                            avglon += tlon
                            countLL += 1
                            
                            let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
                            
                            let nanno = TBSPointAnnotation();
                            //pin.title = "TBS" + currentStationNumber.toString()
                            
                            let ttlfeet = Utilities.haversineFeet(lat1: lcoord.latitude, lon1: lcoord.longitude, lat2: c.coordinate.latitude, lon2: c.coordinate.longitude)
                            ttlLF += ttlfeet
                            nanno.title = ttlfeet.toNumberString(decimalPlaces:0)
                            
                            
                            nanno.identifier = 3
                            nanno.coordinate = ncoord
                            if ttlfeet > 5.0{
                                let show = wallLengthIsOn
                                if show {
                                    map.addAnnotation(nanno)
                                }
                                //annotations.append(pin)
                            }
                            
                            
                            
                        }
                        
                        if firstcoord.latitude == 0{
                            firstcoord = c.coordinate
                        }
                        
                        lcoord = c.coordinate
                        cntNumber += 1
                    }
                }
                if polygonNumber > pgNum || finishPoly {
                    let tlat = (lcoord.latitude + firstcoord.latitude) / 2
                    let tlon = (lcoord.longitude + firstcoord.longitude) / 2
                    
                    let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
                    
                    let nanno = TBSPointAnnotation();
                    //pin.title = "TBS" + currentStationNumber.toString()
                    
                    let ttlfeet = Utilities.haversineFeet(lat1: lcoord.latitude, lon1: lcoord.longitude, lat2: firstcoord.latitude, lon2: firstcoord.longitude)
                    ttlLF += ttlfeet
                    nanno.title = ttlfeet.toNumberString(decimalPlaces:0)
                    
                    
                    nanno.identifier = 3
                    nanno.coordinate = ncoord
                    if ttlfeet > 5.0{
                        let show = wallLengthIsOn
                        if show {
                            map.addAnnotation(nanno)
                        }
                    }
                    
                    lblLinnearFt.text = "LF: " + ttlLF.toNumberString(decimalPlaces: 0) + "ft"
                    homeLF = ttlLF
                    //let flat = avgLat / countLL
                   // let flon = avglon / countLL
                    
                   // let npCoord = CLLocationCoordinate2D(latitude: flat, longitude: flon)
                    //var np = TBSPointAnnotation()
                   // np.title = ttlLF.toNumberString(decimalPlaces: 0)
                   // np.coordinate = npCoord
                   // np.identifier = 30
                    //map.addAnnotation(np)
                   //
                    
                    
                }
            
        }
        
        
        
        var coords = annotationsPoly[pgNum].map({$0.coordinate})
        
        
        
        if finishPoly{
            //let hull = sortConvex(input: coords)
            let polygon = MKPolygon(coordinates: &coords, count: coords.count)
            map.addOverlay(polygon)
            homePoly[pgNum] = polygon
            polygonNumber = polygonNumber + 1
            finishPoly = false
            //firstPolygonCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            annotations.append([TBSPointAnnotation]())
            annotationsPoly.append([TBSPointAnnotation]())
            homePoly.append(nil)
            tmpPolyLine.append(nil)
            
        }else {
            
            if polygonNumber > 0 && pgNum != polygonNumber {
                let polygon = MKPolygon(coordinates: &coords, count: coords.count)
                map.addOverlay(polygon)
                homePoly[pgNum] = polygon
            }else{
                let polyline = baitPolyLine(coordinates: coords, count: coords.count)
                polyline.identifier = 1
                map.addOverlay(polyline)
                tmpPolyLine[polygonNumber] = polyline
                
            }
            
            
            
        }
        
        distBetweenStations()
        
    }
    func updateFootPrintPoints(){
        
        var pts = [[GpsPoint]]()
        
        for a in annotations.indices{
            pts.append([GpsPoint]())
            
            for b in annotations[a]{
                
                pts[a].append(GpsPoint(lat: b.coordinate.latitude, lon: b.coordinate.longitude, accuracy: "", validresult: true, isRooftop: true))
                
                
            }
        }
        
        fpPoints = pts
        let sv = StationHomeData(footPrint: pts, stations: baitStations, additionalConditions: additionalConditions, footPrintNeedsVerified: footprintNeedsVerified)
        DataUtilities.saveTBSCheckData(tbsList: sv, workOrderId: routeStop.workorder_id)
        
    }
    
    func addTempAnnotationsForPoly(_ polyNum: Int){
       
        updateFootPrintPoints()
        annotationsPoly[polyNum] = [TBSPointAnnotation]()
        //var lastwastemp = false
        
        var lastpin:TBSPointAnnotation!
        
        
        
        for i in annotations[polyNum].indices{
            
            if i > 0{
                
                
                
                
                //if lastwastemp == false {
                    
                    let pin = TBSPointAnnotation();
                    pin.title = "Delete?"
                    
                    
                    pin.identifier = 20
                    
                    pin.polyNumber = polyNum
                    
                    let tlat = (lastpin.coordinate.latitude + annotations[polyNum][i].coordinate.latitude) / 2
                    let tlon = (lastpin.coordinate.longitude + annotations[polyNum][i].coordinate.longitude) / 2
                    
                    let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
                
                let feet = Utilities.haversineFeet(lat1: lastpin.coordinate.latitude , lon1: lastpin.coordinate.longitude , lat2: annotations[polyNum][i].coordinate.latitude, lon2: annotations[polyNum][i].coordinate.longitude)
                    pin.stationNumber = i
                    
                    pin.coordinate = ncoord
                if feet > 5.5{
                    
                    if footprintNeedsVerified {
                        map.addAnnotation(pin)
                        
                        //annotations[polygonNumber].append(pin)
                        //coords.append(touchMapCoordinate)
                        
                        //drawPolylineOrPolygon(pgNum: polygonNumber)
                        //let inAt = i - 1;
                        // map.addAnnotation(pin)
                        annotationsPoly[polyNum].append(pin)
                        //i = i + 1
                    }
                }
               // }
            }
            //else{
                annotationsPoly[polyNum].append(annotations[polyNum][i])
            //}
            
            //if lastwastemp == false {
                lastpin = annotations[polyNum][i]
            
            
            //}
            //if annotations[polyNum][i].identifier == 20 {
            //    lastwastemp = true
            //}else{
             //   lastwastemp = false
            //}
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    func distBetweenStations(){
        
        
         if let bp = baitpolys {
             map.removeOverlay(bp)
             baitpolys = nil
                 
         }
        
        let anno = map.annotations
        for a in anno{
            if let p = a as? TBSPointAnnotation{
                if  p.identifier == 30{
                    
                    // coords.append(p.coordinate)
                    map.removeAnnotation(p)
                }
                
            }
            
            
            
        }
           var coordList = [CLLocationCoordinate2D]()
              
                var lcoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                var firstcoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                var cntNumber = 0
                for c in baitStations {
                    //if c.identifier == 2{
                        if lcoord.latitude != 0{
                            
                            let tlat = (lcoord.latitude + c.lat) / 2
                            let tlon = (lcoord.longitude + c.lon) / 2

                            let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
                            
                            let nanno = TBSPointAnnotation();
                            //pin.title = "TBS" + currentStationNumber.toString()
                            
                                        let ttlfeet = Utilities.haversineFeet(lat1: lcoord.latitude, lon1: lcoord.longitude, lat2: c.lat, lon2: c.lon)
                           
                            nanno.title = ttlfeet.toNumberString(decimalPlaces:0)
                            
                            
                            nanno.identifier = 30
                            nanno.coordinate = ncoord
                            if ttlfeet > 4.5{
                                let show = StationDistanceIsOn
                                if show {
                                    map.addAnnotation(nanno)
                                }
                                //annotations.append(pin)
                            }
                            
                            
                            
                        }
                        
                        if firstcoord.latitude == 0{
                                
                                firstcoord = CLLocationCoordinate2D(latitude: c.lat, longitude: c.lon)
                        }
                        
                        lcoord = CLLocationCoordinate2D(latitude: c.lat, longitude: c.lon)
                    
                    coordList.append(lcoord)
                        cntNumber += 1
                    //}
                }
        
        if baitStations.count > 4 {
            let tlat = (lcoord.latitude + firstcoord.latitude) / 2
            let tlon = (lcoord.longitude + firstcoord.longitude) / 2
            
            let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
            
            let nanno = TBSPointAnnotation();
            //pin.title = "TBS" + currentStationNumber.toString()
            
            let ttlfeet = Utilities.haversineFeet(lat1: lcoord.latitude, lon1: lcoord.longitude, lat2: firstcoord.latitude, lon2: firstcoord.longitude)
            
            nanno.title = ttlfeet.toNumberString(decimalPlaces:0)
            
            
            nanno.identifier = 30
            nanno.coordinate = ncoord
            if ttlfeet > 4.5{
                let show = StationDistanceIsOn
                if show {
                    map.addAnnotation(nanno)
                }
             
            }
            
            let lastcoord = CLLocationCoordinate2D(latitude: baitStations[0].lat, longitude: baitStations[0].lon)
            coordList.append(lastcoord)
        }
        
        
        
        
        
        
        let show = StationDistanceIsOn
        if show{
            
        
        
                let polyline = baitPolyLine(coordinates: coordList, count: coordList.count)
                polyline.identifier = 2
                map.addOverlay(polyline)
                baitpolys = polyline

        }
            
            
        
        
        
    }
    
    
    func distTrench(){
        
        let anno = map.annotations
        for a in anno{
            if let p = a as? TBSPointAnnotation{
                if  p.identifier == 31{
                    
                    // coords.append(p.coordinate)
                    map.removeAnnotation(p)
                }
                
            }
            
            
            
        }
        
        if let tp = trenchPolys{
           // for t in tp{
                
                map.removeOverlays(tp)
            //}
           // trenchPolys = nil
            
            
        }
                
        trenchPolys = [baitPolyLine]()
          
        if let act = additionalConditions{
            
        
            
            
            var ac = [TermiteCondition]()
            
            for t in act{
                if t.typeId == 96{
                    ac.append(t)
                }
            }
            
            var ttlLiquidFeet = 0.0
            
            
            
            
            for i in ac.indices {
                //if c.identifier == 2{
                
                
                if i > 0 {
                    if ((i-1) % 2) == 0{
                        
                        
                        
                        let tlat = (ac[i-1].lat + ac[i].lat) / 2
                        let tlon = (ac[i-1].lon + ac[i].lon) / 2
                        
                        let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
                        
                        let nanno = TBSPointAnnotation();
                        //pin.title = "TBS" + currentStationNumber.toString()
                        
                        let ttlfeet = Utilities.haversineFeet(lat1: ac[i-1].lat, lon1: ac[i-1].lon, lat2: ac[i].lat, lon2: ac[i].lon)
                        
                        nanno.title = ttlfeet.toNumberString(decimalPlaces:0)
                        
                        ttlLiquidFeet += ttlfeet
                        
                        nanno.identifier = 31
                        nanno.coordinate = ncoord
                        if ttlfeet > 4.5{
                            let show = StationDistanceIsOn
                            if show {
                                map.addAnnotation(nanno)
                            }
                            //annotations.append(pin)
                        }
                        
                        var coordList = [CLLocationCoordinate2D]()
                        coordList.append(CLLocationCoordinate2D(latitude: ac[i-1].lat, longitude: ac[i-1].lon))
                        coordList.append(CLLocationCoordinate2D(latitude: ac[i].lat, longitude: ac[i].lon))
                        let polyline = baitPolyLine(coordinates: coordList, count: coordList.count)
                        polyline.identifier = 31
                        map.addOverlay(polyline)
                        trenchPolys?.append(polyline)
                        
                    }
                }
            }
            
            
             var acc = [TermiteCondition]()
            
            for t in act{
                if t.typeId == 97{
                    acc.append(t)
                }
            }
            
            
            
            
            
            for i in acc.indices {
                //if c.identifier == 2{
                
                
                if i > 0{
                    if ((i-1) % 2) == 0{
                        
                        
                        
                        let tlat = (acc[i-1].lat + acc[i].lat) / 2
                        let tlon = (acc[i-1].lon + acc[i].lon) / 2
                        
                        let ncoord = CLLocationCoordinate2D(latitude: tlat, longitude: tlon)
                        
                        let nanno = TBSPointAnnotation();
                        //pin.title = "TBS" + currentStationNumber.toString()
                        
                        let ttlfeet = Utilities.haversineFeet(lat1: acc[i-1].lat, lon1: acc[i-1].lon, lat2: acc[i].lat, lon2: acc[i].lon)
                        
                        nanno.title = ttlfeet.toNumberString(decimalPlaces:0)
                        
                        ttlLiquidFeet += ttlfeet
                        
                        nanno.identifier = 31
                        nanno.coordinate = ncoord
                        if ttlfeet > 4.5{
                            let show = StationDistanceIsOn
                            if show {
                                map.addAnnotation(nanno)
                            }
                            //annotations.append(pin)
                        }
                        
                        var coordList = [CLLocationCoordinate2D]()
                        coordList.append(CLLocationCoordinate2D(latitude: acc[i-1].lat, longitude: acc[i-1].lon))
                        coordList.append(CLLocationCoordinate2D(latitude: acc[i].lat, longitude: acc[i].lon))
                        let polyline = baitPolyLine(coordinates: coordList, count: coordList.count)
                        polyline.identifier = 31
                        map.addOverlay(polyline)
                        trenchPolys?.append(polyline)
                        
                    }
                }
                
            }
            
            
            ttlLiquidLF = ttlLiquidFeet
            
            let s = StationHomeData(footPrint: fpPoints, stations: baitStations, additionalConditions: additionalConditions, footPrintNeedsVerified: footprintNeedsVerified)
            
            DataUtilities.saveTBSCheckData(tbsList: s, workOrderId: routeStop.workorder_id)
            
                
        }

        
        
        
        
        
      
        
                

                
            
            
        
        
        
    }
    
    
    
    func takeScreenShotOfHome() -> UIImage?{
        

        let bounds = UIScreen.main.bounds
        //let size = bounds.size
        let height = bounds.height - 370
        let width = bounds.width
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            self.view.drawHierarchy(in: CGRectMake(0, -370, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        
        
        return img
           // let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
       // activityViewController.popoverPresentationController?.sourceView = self.view
        
            //self.present(activityViewController, animated: true, completion: nil)
        }
    
    
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if segue.identifier == "showTermiteCheckResults" {
                
                let destinationController = segue.destination as! viewTermiteBaitCheckResults
                destinationController.HrEmpId = appDelegate.hrEmpId ?? ""
                destinationController.routeStop = routeStop
                destinationController.baitStations = baitStations
                destinationController.additionalConditions = additionalConditions
                destinationController.ttlLiquidLF = ttlLiquidLF
                destinationController.homeLF = homeLF
                destinationController.fpPoints = fpPoints
                let img = takeScreenShotOfHome()
                destinationController.houseimage = img
                
                
            }
            
            //showTbsMapPopover
            if segue.identifier == "showTbsMapPopover" {
                let destinationController = segue.destination as! viewTBSMapPopover
                destinationController.myLocIsOn = myLocIsOn
                destinationController.wallLengthIsOn = wallLengthIsOn
                destinationController.StationDistanceIsOn = StationDistanceIsOn
                
                
            }
            
        }
    
        
    @IBAction func btnLocationAction(_ sender: Any) {
        
        
        
        mapTop.constant = 300
        self.view.layoutIfNeeded()
        //takeScreenShotOfHome()
        
        
        //let location = map.userLocation
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        
           
           //let region = MKCoordinateRegion(center: center, latitudinalMeters: 50,longitudinalMeters: 50)
           //self.map.setRegion(region, animated: true)
        
    }
    

        
    
}
extension viewTBSMap : MKMapViewDelegate {
  //DELEGATE FUNCTIONS
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      //  let ulat = userLocation.coordinate.latitude
       // let ulon = userLocation.coordinate.longitude
        
        if let tf = selectedTBS{
            tf.didUpdateLocationOfUser(userLoc: userLocation)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If you're showing the user's location on the map, don't set any view
        if annotation is MKUserLocation {
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "currentUser")
               
               if annotationView == nil {
                   //Create View
                   annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "currentUser")
                   
               } else {
                   //Assign annotation
                   annotationView?.annotation = annotation
               }
            
                //annotationView?.isDraggable = true
               //Set image
               //switch annotation.title {
               //case "end":
        let pi = UIImage(systemName: "location.circle.fill")
        let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
            view.tintColor = .systemBlue
                UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()!
                view.layer.render(in: graphicsContext)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                //self.image = image
        
        

        let size = CGSize(width: 30, height: 30)
                UIGraphicsBeginImageContext(size)
                image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

                annotationView?.image = resizedImage
        //annotationView?.image =
                  //annotationView?.isDraggable = true
    
    //annotationView?.canShowCallout = true
    //annotationView?.isDraggable = true
    //annotationView?.calloutOffset = CGPoint(x: 0, y: 0)
    annotationView?.rightCalloutAccessoryView = UIButton(type: .close)
    
    
    
        annotationView?.tintColor = .purple
        //annotationView?.
               //case "start":
               //    annotationView?.image = UIImage(named: "pinStart")
              // default:
              //     break
              // }
               
               return annotationView
            //return nil
            
            
            
            
        }
            
        
        guard let annotation = annotation as? TBSPointAnnotation else {
            return nil
        }
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
       
       
            //view.annotation = annotation

         
        // Balloon Shape Pin (iOS 11 and above)

            if annotation.identifier == 1 { //baitstation marker not complete
                if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                    view.titleVisibility = .adaptive // Set Title to be always visible
                    view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                    view.markerTintColor = .orange
                    view.displayPriority = .required// Background color of the balloon shape pin
                    view.glyphImage = UIImage(named: "TermiteBaitStation") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                    //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                    view.glyphTintColor = .darkGray // The color of the image if this is a icon
                    view.canShowCallout = true
                    view.isDraggable = true
                    view.calloutOffset = CGPoint(x: 0, y: 0)
                    view.rightCalloutAccessoryView = UIButton(type: .contactAdd)
                    return view
                }
            }
        else if annotation.identifier == 10 { //bait statio nmarker complete
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .adaptive // Set Title to be always visible
                view.subtitleVisibility = .adaptive // Set Subtitle to be always visible
                view.markerTintColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(named: "TermiteBaitStation") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .contactAdd)
                return view
            }
        }
        else if annotation.identifier == 200{
            
            
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .purple
                view.displayPriority = .required// Background color of the balloon shape pin
                //view.glyphImage = UIImage(named: "TermiteBaitStation") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .purple // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
            
            
            //view.titleVisibility = .hidden // Set Title to be always visible
            //view.subtitleVisibility = .hidden // Set Subtitle to be always visible
            //  if let view = mapView.dequeueReusableAnnotationView(withIdentifier: "custom") as? MKMarkerAnnotationView {
            //view.image =  UIImage(systemName: "circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            
            //view.displayPriority = .required// Background color of the balloon shape pin
            //view.glyphImage = UIImage(systemName: "square.fill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
            //view.glyphText = annotation.stopNumber.toString() // Text instead of image
            //view.glyphTintColor = .white // The color of the image if this is a icon
            //view.canShowCallout = false
            
            //return view
        }else if annotation.identifier == 20 || annotation.identifier == 2 {
            
            var imgname = "circle.fill"
            var dotsize = 15
            var color = UIColor.purple
            
            if annotation.identifier == 20{
                color = UIColor.systemPurple
                dotsize = 12
                imgname = "square.fill"
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custommd")
               
               if annotationView == nil {
                   //Create View
                   annotationView = CornerAnnotationView(annotation: annotation, reuseIdentifier: "custommd", mapview: map)
                   
               } else {
                   //Assign annotation
                   annotationView?.annotation = annotation
               }
            
        annotationView?.isDraggable = true
               //Set image
               //switch annotation.title {
               //case "end":
        let pi = UIImage(systemName: imgname)
        let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
            view.tintColor = color
                UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()!
                view.layer.render(in: graphicsContext)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                //self.image = image
        
        

        let size = CGSize(width: dotsize, height: dotsize)
                UIGraphicsBeginImageContext(size)
                image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

                annotationView?.image = resizedImage
        //annotationView?.image =
                  //annotationView?.isDraggable = true
    
    //annotationView?.canShowCallout = true
    //annotationView?.isDraggable = true
    //annotationView?.calloutOffset = CGPoint(x: 0, y: 0)
    annotationView?.rightCalloutAccessoryView = UIButton(type: .close)
    
    
    
        annotationView?.tintColor = .purple
        //annotationView?.
               //case "start":
               //    annotationView?.image = UIImage(named: "pinStart")
              // default:
              //     break
              // }
               
               return annotationView
            
            
            
       // }
}else if annotation.identifier == 201{
                   

                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customcr")
                       
                       if annotationView == nil {
                           //Create View
                           annotationView = CornerAnnotationView(annotation: annotation, reuseIdentifier: "customcr", mapview: map)
                       } else {
                           //Assign annotation
                           annotationView?.annotation = annotation
                       }
                       
                annotationView?.isDraggable = true
                       //Set image
                       //switch annotation.title {
                       //case "end":
                let pi = UIImage(named: "draggableMarker")
                //let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
               // view.tintColor = .purple
               //         UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
              //  let graphicsContext = UIGraphicsGetCurrentContext()!
                //        view.layer.render(in: graphicsContext)
               //         let image = UIGraphicsGetImageFromCurrentImageContext()
                //        UIGraphicsEndImageContext()
                        //self.image = image
                
                

                let size = CGSize(width: 150, height: 150)
                        UIGraphicsBeginImageContext(size)
                        pi!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

                        annotationView?.image = resizedImage
                //annotationView?.image =
                          //annotationView?.isDraggable = true
            
            annotationView?.canShowCallout = true
            //annotationView?.isDraggable = true
            annotationView?.calloutOffset = CGPoint(x: 0, y: 0)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .close)
    annotationView?.rightCalloutAccessoryView?.tintColor = .red
            
            
            
                annotationView?.tintColor = .purple
                //annotationView?.
                       //case "start":
                       //    annotationView?.image = UIImage(named: "pinStart")
                      // default:
                      //     break
                      // }
                       
                       return annotationView
                    
                    
                    
               // }
}else if annotation.identifier == 3 {
            let annotationIdentifier = "MyCustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
                if annotationView == nil {
                  annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                  if case let annotationView as CustomAnnotationView = annotationView {
                    annotationView.isEnabled = true
                    annotationView.canShowCallout = false
                    annotationView.label = UILabel(frame: CGRect(x: 0, y: 0, width: 50.0, height: 25))
                    if let label = annotationView.label {
                      label.font = UIFont(name: "HelveticaNeue", size: 16.0)
                      label.textAlignment = .center
                      label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                      label.adjustsFontSizeToFitWidth = true
                      annotationView.addSubview(label)
                    }
                  }
                }

    if case let annotationView as CustomAnnotationView = annotationView {
      annotationView.annotation = annotation
        let pi = UIImage(systemName: "square.fill")
        let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
        view.tintColor = .blue
                UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()!
                view.layer.render(in: graphicsContext)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                    let size = CGSize(width: 50, height: 25)
                            UIGraphicsBeginImageContext(size)
                            image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                  annotationView.image = resizedImage
                  if let title = annotation.title,
                    let label = annotationView.label {
                    label.text = title
                  }
                }
            annotationView?.centerOffset = CGPoint(x: 0, y: 0)

                return annotationView
    
    
        }else if annotation.identifier == 30 || annotation.identifier == 31{
            let annotationIdentifier = "MyCustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
                if annotationView == nil {
                  annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                  if case let annotationView as CustomAnnotationView = annotationView {
                    annotationView.isEnabled = true
                    annotationView.canShowCallout = false
                    annotationView.label = UILabel(frame: CGRect(x: 0, y: 0, width: 40.0, height: 25))
                    if let label = annotationView.label {
                      label.font = UIFont(name: "HelveticaNeue", size: 16.0)
                      label.textAlignment = .center
                        label.textColor = .white
                      label.adjustsFontSizeToFitWidth = true
                      annotationView.addSubview(label)
                    }
                  }
                }

                if case let annotationView as CustomAnnotationView = annotationView {
                  annotationView.annotation = annotation
                    let pi = UIImage(systemName: "square.fill")
                    let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
                    view.tintColor = .darkGray
                    if annotation.identifier == 31{
                        view.tintColor = .systemBlue
                    }
                    
                            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
                    let graphicsContext = UIGraphicsGetCurrentContext()!
                            view.layer.render(in: graphicsContext)
                            let image = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                    
                    
                    let size = CGSize(width: 40, height: 25)
                    
                            UIGraphicsBeginImageContext(size)
                            image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                  annotationView.image = resizedImage
                  if let title = annotation.title,
                    let label = annotationView.label {
                    label.text = title
                  }
                }
            annotationView?.centerOffset = CGPoint(x: 0, y: 0)

                return annotationView
            
        } else if annotation.identifier == 91 { //termite damage
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .darkGray
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "bolt.horizontal") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }else if annotation.identifier == 92 { //conducive condition
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .darkGray
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "exclamationmark.triangle") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }else if annotation.identifier == 93 { //active termites
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .darkGray
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(named: "termite") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }else if annotation.identifier == 94 { //mud tubes
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .darkGray
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "water.waves") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white //UIColor(red: 0.7, green: 0.44, blue: 0.24, alpha: 1.0) // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }else if annotation.identifier == 95 { //previous infestation
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .darkGray
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(systemName: "clock.arrow.circlepath") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }else if annotation.identifier == 96 { //trenching
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .systemBlue
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(named: "ShovelSF2") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }else if annotation.identifier == 97 { //trenching
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
                view.titleVisibility = .hidden // Set Title to be always visible
                view.subtitleVisibility = .hidden // Set Subtitle to be always visible
                view.markerTintColor = .systemBlue
                view.displayPriority = .required// Background color of the balloon shape pin
                view.glyphImage = UIImage(named: "drill") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                //view.glyphText = annotation.stopNumber.toString() // Text instead of image
                view.glyphTintColor = .white // The color of the image if this is a icon
                view.canShowCallout = true
                view.isDraggable = true
                view.calloutOffset = CGPoint(x: 0, y: 0)
                view.rightCalloutAccessoryView = UIButton(type: .close)
                return view
            }
        }
        
            

                    
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKTileOverlay{
            let mktile = overlay as! MKTileOverlay
            return MyCustomOverlayRenderer(overlay: overlay)
        }
            
        
        
        if overlay is MKCircle {
                let renderer = MKCircleRenderer(overlay: overlay)
                renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 2
                return renderer
            
            } else if overlay is MKPolyline {
                if let nover = overlay as? baitPolyLine {
                    
                    if nover.identifier == 2{
                        let renderer = MKPolylineRenderer(overlay: overlay)
                        renderer.strokeColor = UIColor.darkGray
                        renderer.lineWidth = 2
                        return renderer
                    
                    }else if nover.identifier == 31{
                        let renderer = MKPolylineRenderer(overlay: overlay)
                        renderer.strokeColor = .systemBlue
                        renderer.lineWidth = 2
                        return renderer
                    
                    }else{
                        let renderer = MKPolylineRenderer(overlay: overlay)
                        renderer.strokeColor = UIColor.purple
                        renderer.lineWidth = 6
                        return renderer
                    
                    }
                    
                    
                    
                }else{
                    let renderer = MKPolylineRenderer(overlay: overlay)
                    renderer.strokeColor = UIColor.purple
                    renderer.lineWidth = 6
                    return renderer
                
                }
                
               
            } else if overlay is MKPolygon {
                let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
                renderer.fillColor = UIColor.purple.withAlphaComponent(0.5)
                renderer.strokeColor = UIColor.purple
                renderer.lineWidth = 4
                return renderer
            }
        
        
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.setColors([
            .purple
        ], locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 6.0
    return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      //let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "modalWeb") as! viewModalWeb
        
        
        if let atmPin = view.annotation as? TBSPointAnnotation
        {
            
            
            
            if atmPin.identifier == 1 || atmPin.identifier == 10{
                
                var ns = StationCheck(workOrderItemId: 0, barcode: "", result: "", photoBase64: "", lat: 0, lon: 0, timeChecked: 0, stationNumber: 0, isNew: false, id:0)
                
                for n in baitStations{
                    if n.stationNumber == atmPin.stationNumber{
                        ns = n
                    }
                }
                
                
                let customView = self.storyboard?.instantiateViewController(withIdentifier: "viewTBSCheck") as? viewStationCheck
                customView?.title = atmPin.title
                customView?.stationData = ns
                customView?.modalTransitionStyle = .crossDissolve
                customView?.modalPresentationStyle = .formSheet
                selectedTBS = customView
                self.present(customView!,animated:true, completion:nil)

            }else if atmPin.identifier == 2{
                
                map.removeAnnotation(atmPin)
                var indexToRemove = -1
                for i in annotations[atmPin.polyNumber].indices{
                    if atmPin.isEqual(annotations[atmPin.polyNumber][i]){
                        indexToRemove = i
                    }
                }
                
                annotations[atmPin.polyNumber].remove(at: indexToRemove)
                drawPolylineOrPolygon(pgNum: atmPin.polyNumber)
            }else if atmPin.identifier ?? 0 > 90 && atmPin.identifier ?? 0 < 100 {
                
                map.removeAnnotation(atmPin)
                
                var indexToRemove = -1
                if let ac = additionalConditions{
                    
                
                for i in ac.indices{
                    if atmPin.stationId == ac[i].markerId{
                        indexToRemove = i
                    }
                }
                }
                additionalConditions?.remove(at: indexToRemove)
                
                
            }


      
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
       print("didSelectAnnotationTapped")
        
        /*
        let selectedAnnotation = view.annotation as? TBSPointAnnotation
            for annotation in mapView.annotations {
                if let annotation = annotation as? TBSPointAnnotation, !annotation.isEqual(selectedAnnotation) {
                    // do some actions on non-selected annotations in 'annotation' var
                    annotation
                }
            }
        */
        
        if let atmPin = view.annotation as? TBSPointAnnotation
        {
            
            /*
            let anno = map.annotations
            
            for a in anno{
                if let p = a as? TBSPointAnnotation{
                    if p != atmPin{
                        let av = map.view(for: p)
                        av?.setSelected(false, animated: true)
                        //map.deselectAnnotation(p, animated: false)
                    }
                }
            }
            */
            
                if annotations[polygonNumber].count > 3 {
                    if atmPin == annotations[polygonNumber][0]  {
                        finishPoly = true
                        drawPolylineOrPolygon(pgNum: atmPin.polyNumber)
                }
                
                
            }
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {

        // The map view retains a reference to the same annotations in the array.
        // The annotation in the array is automatically updated when the pin is moved.

            //updateOverlay()
        if newState == .none {
            if let annotation = view.annotation as? TBSPointAnnotation  {
                //return nil
                let annoId = annotation.identifier ?? 0
                
                if annoId == 1 || annoId == 10{
                    
                    
                    if let row = self.baitStations.firstIndex(where: {$0.stationNumber == annotation.stationNumber}) {
                        baitStations[row].lat = annotation.coordinate.latitude
                        baitStations[row].lon = annotation.coordinate.longitude
                        distBetweenStations()
                        //updateStationMarkerColor()
                    }
                    
                    
                } else if annoId == 2 || annoId == 20 {
                    
                    
                    
                    
                    if annotation.identifier == 20{
                        annotation.identifier = 2
                        annotations[annotation.polyNumber].insert(annotation, at: annotation.stationNumber)
                        //addTempAnnotationsForPoly(annotation.polyNumber)
                    }
                    
                    drawPolylineOrPolygon(pgNum: annotation.polyNumber)
                }else if annoId > 90 && annoId < 100 {
                    
                    if let row = additionalConditions?.firstIndex(where: {$0.markerId == annotation.stationId}){
                        
                        additionalConditions?[row].lat = annotation.coordinate.latitude
                        additionalConditions?[row].lon = annotation.coordinate.longitude
                        if annotation.identifier == 96 || annotation.identifier == 97{
                            distTrench()
                        }
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        }

    
}
extension viewTBSMap:StationCheckDelegate{
    func didDeleteStation(stationInfo: StationCheck) {
        if let row = self.baitStations.firstIndex(where: {$0.stationNumber == stationInfo.stationNumber}) {
            baitStations.remove(at: row)
            updateStationMarkerColor()
        }
    }
    
    func didUpdateStationCheck(stationInfo: StationCheck) {
        if let row = self.baitStations.firstIndex(where: {$0.stationNumber == stationInfo.stationNumber}) {
               baitStations[row] = stationInfo
            updateStationMarkerColor()

        }
    }
    
    
}

extension viewTBSMap:TBSMapToggleDelegate{
    func pressedAddBaitStation() {
        stage = 4
        checkStations()
        stage = 5
    }
    
    func pressedTrenching() {
        addConditionstoMapManually(typeId: 96)
    }
    
    func pressedAddDrillLoc() {
        addConditionstoMapManually(typeId: 97)
    }
    
    func toggleMyLocation(isOn: Bool) {
      
            map.showsUserLocation = isOn
            myLocIsOn = isOn
     
        
        
        
    }
    
    func toggleWallLength(isOn: Bool) {
        wallLengthIsOn = isOn
        drawPolylineOrPolygon(pgNum: polygonNumber)
    }
    
    func toggleStationDist(isOn: Bool) {
        
        StationDistanceIsOn = isOn
        
        distBetweenStations()
    }
    
    func pressedTermiteDamage() {
        addConditionstoMapManually(typeId: 91)
    }
    
    func pressedConduciveCondition() {
        addConditionstoMapManually(typeId: 92)
    }
    
    func pressedActiveTermites() {
        addConditionstoMapManually(typeId: 93)
    }
    
    func pressedMudTubes() {
        addConditionstoMapManually(typeId: 94)
    }
    
    func pressedPreviousInfestation() {
        addConditionstoMapManually(typeId: 95)
    }
    
    func pressedEditHome() {
        footprintNeedsVerified = true
        stage = 1
        nextStep(false)
        drawPolylineOrPolygon(pgNum: polygonNumber)
    }
    
    
}



class TBSPointAnnotation : MKPointAnnotation {
    var identifier: Int?
    var stationNumber: Int = 0
    var stationId:String = ""
    var polyNumber:Int = 0
    
  
   
}
class CornerAnnotationView :MKAnnotationView {
    dynamic var mapV:MKMapView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    init(annotation: MKAnnotation?, reuseIdentifier: String?, mapview: MKMapView) {
    mapV = mapview
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("custom touch began")
        self.setSelected(true, animated: true)
        super.touchesBegan(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches ended")
        //self.setSelected(false, animated: true)
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
       // let loc = mapV.convert(self.center, toCoordinateFrom: self.superview)
        
        
        super.touchesMoved(touches, with: event)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        isSelected = selected
        if selected{
            
            let pi = UIImage(named: "draggableMarker")
            //let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
            //view.tintColor = .purple
                    //UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
            //let graphicsContext = UIGraphicsGetCurrentContext()!
                    //view.layer.render(in: graphicsContext)
                   // let image = UIGraphicsGetImageFromCurrentImageContext()
                   // UIGraphicsEndImageContext()
                    //self.image = image
            
            

            let size = CGSize(width: 150, height: 150)
                    UIGraphicsBeginImageContext(size)
                    pi!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

                    self.image = resizedImage
        }else{
            
            var imgname = "circle.fill"
            var dotsize = 15
            var color = UIColor.purple
            
            
            if let anno = self.annotation as? TBSPointAnnotation{
                
                if anno.identifier == 20{
                    color = UIColor.systemPurple
                    dotsize = 12
                    imgname = "square.fill"
                }
                
            }
            
            
            let pi = UIImage(systemName: imgname)
            let view = UIImageView(image: pi?.withRenderingMode(.alwaysTemplate))
            
            view.tintColor = color
            
            
       
            
                    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
            let graphicsContext = UIGraphicsGetCurrentContext()!
                    view.layer.render(in: graphicsContext)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    //self.image = image
            
            

            let size = CGSize(width: dotsize, height: dotsize)
                    UIGraphicsBeginImageContext(size)
                    image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

                    self.image = resizedImage
        }
    }
    
    
    override func setDragState(_ newDragState: MKAnnotationView.DragState, animated: Bool) {
        if newDragState == .starting{
            self.canShowCallout = false
            dragState = .dragging
            let pi = UIImage(named: "draggableMarker")
           
            let size = CGSize(width: 150, height: 150)
                    UIGraphicsBeginImageContext(size)
                    pi!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

                    self.image = resizedImage
        }
        
        if newDragState == .dragging{
            self.canShowCallout = false
        }
        
        if newDragState == .canceling{
            dragState = .none
            self.canShowCallout = true
            self.setSelected(false, animated: true)
        }
        if newDragState == .ending{
            dragState = .none
            self.canShowCallout = true
            self.setSelected(false, animated: true)
        }
        
    }
    
    
    
    
}

class baitPolyLine: MKPolyline{
    var identifier:Int = 0
}
class CustomAnnotationView: MKAnnotationView {
  var label: UILabel?

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
class MyCustomOverlayRenderer: MKOverlayRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let drawRect = self.rect(for: mapRect)
        context.setFillColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
        context.fill(drawRect)
    }
}
extension MKMapView {
    
    func fitAllAnnotations(with padding: UIEdgeInsets = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let annotationPoint = MKMapPoint($0.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        })
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
    
    func fit(annotations: [MKAnnotation], andShow show: Bool, with padding: UIEdgeInsets = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let aPoint = MKMapPoint($0.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.isNull ? rect : zoomRect.union(rect)
        })
        
        if show {
            addAnnotations(annotations)
        }
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
}
