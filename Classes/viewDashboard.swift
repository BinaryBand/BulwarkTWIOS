//
//  viewDashboard.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/21/22.
//

import UIKit

class viewDashboard: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITabBarDelegate {
    
    @IBOutlet var cvPhotos: UICollectionView!
    
    @IBOutlet var tabbar: UITabBar!
    
    @IBOutlet var tabBarItemChat: UITabBarItem!
    
    @IBOutlet var tabBarReports: UITabBarItem!
    
    var wichUrl:Int!
    var tabUrl:String!
    
    var photoList: [ExcelentPhotos] = []
    var photoListImages:[UIImage] = []
    
    var hrempid:String!
    
    var useCookieInWeb:Bool!
    
    @IBOutlet var lblVin: UILabel!
    
    
    @IBOutlet var lblOdo: UILabel!
    
    @IBOutlet var lblDtcDist: UILabel!
    
    @IBOutlet var viewPhotoRatio: DesignableUIView!
    
    //@IBOutlet var cvSales: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //cvSales.delegate = self
        //cvSales.dataSource = self
        cvPhotos.delegate = self
        cvPhotos.dataSource = self
        tabbar.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        hrempid = appDelegate.hrEmpId ?? ""
        
        appDelegate.viewDash = self
        
        //let obd =
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapPhotoRatio (_:)))
        
        self.viewPhotoRatio.addGestureRecognizer(gesture)
        
        //cvPhotos.reloadData()
        loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabbar.selectedItem = tabbar.items![0]
    }
    
    
    func loadPhotos(){
        
        
        self.view.makeToastActivity(.center)
        
        
        
        
        Task {
            
            do {
                
                photoList = try await JsonFetcher.fetchExcelentPhotosAsync(hrempid: "")
                
                // Update collection view content
                self.cvPhotos.reloadData()
                
                //HUD.hide(true)
                self.view.hideToastActivity()
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }
        
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           performSegue(withIdentifier: "showPhoto", sender: nil)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return photoList.count
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        //cell.layer.borderColor = UIColor.blue.cgColor
        //cell.layer.borderWidth = 1
        //cell.layer.cornerRadius = 4
        
        
        Task {
            
            do {
                
                if let url = photoList[indexPath.row].MediaUrl {
                    
                    let img = try await JsonFetcher.fetchPhotoAsync(urlStr: url)
                    
                    // Update collection view content
                    
                    
                    //HUD.hide(true)
                    //collectionView.hideToastActivity()
                    
                    
                    
                    
                    //let img = UIImage(named: "gbtest")
                    //print(img.size.width as Any)
                    cell.imgThumb.image = img
                }
                //photoListImages.append(img)
                
               // self.cvPhotos.reloadData()
                
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
            
            
            
            
        }
        
        
        return cell
        
    }
        
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
        
       }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showPhoto" {
               if let indexPaths = cvPhotos.indexPathsForSelectedItems{
                   let destinationController = segue.destination as! viewPhoto
                   destinationController.TakenBy = photoList[indexPaths[0].row].AccountNumber
                   destinationController.TakenOn = photoList[indexPaths[0].row].Date
                   destinationController.Rating = photoList[indexPaths[0].row].MarketingGrade
                   destinationController.TakenBy = photoList[indexPaths[0].row].ProName
                   //destinationController.image.image = photoListImages[indexPaths[0].row]
                   destinationController.MediaUrl = photoList[indexPaths[0].row].MediaUrl
                   destinationController.Office1 = photoList[indexPaths[0].row].OfficeName
                   cvPhotos.deselectItem(at: indexPaths[0], animated: false)
               }
           }
        
        
        
        if segue.identifier == "showWeb" {
            
            

            
                let destinationController = segue.destination as! viewModalWeb
                destinationController.url = tabUrl
            destinationController.hrEmpId = hrempid
          
            if let uc = useCookieInWeb{
                destinationController.useCookie = uc
            }
            
            
        }

        if segue.identifier == "showMyPhotos" {
            
            
                   
            
                let destinationController = segue.destination as! viewMyPhotos
                destinationController.hrempid = hrempid
   
            
        }

        
        
       }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item == tabBarItemChat) {
            // Code for item 1
            tabUrl = "https://kpwebapi2.bulwarkapp.com/chat?hrempid=" + hrempid
            useCookieInWeb = true
            print(tabUrl!)
            performSegue(withIdentifier: "showWeb", sender: nil)
            
            
            
        }
        if(item == tabBarReports) {
            tabUrl = "https://dashboard.bulwarkapp.com/mgrapp2/techstatsipad.aspx?h=" + hrempid
            useCookieInWeb = false
            performSegue(withIdentifier: "showWeb", sender: nil)        }
    }
    

    @IBAction func ChatClicked(){
        
        
       
    }
    
    @IBAction func btnIsExtended(_ sender: Any) {
        
        tabUrl = "https://dashboard.bulwarkapp.com/mgrapp2/isextendeddaysoff2.aspx?h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
    }
    
    
    @IBAction func myPhotosClick(_ sender: Any) {
        
        performSegue(withIdentifier: "showMyPhotos", sender: nil)   
    }
    
    @IBAction func btnSalesClick(_ sender: Any) {
        
        tabUrl = "https://fbf2.bulwarkapp.com/mgrapp2/salesstats.aspx?h=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
        
    }
    
    @objc func tapPhotoRatio(_ sender:UITapGestureRecognizer){
        // do other task
        
        tabUrl = "https://servicesnapshot.bulwarkapp.com?&hrempid=" + hrempid
        useCookieInWeb = false
        performSegue(withIdentifier: "showWeb", sender: nil)
        
    }
    
    
    
}
