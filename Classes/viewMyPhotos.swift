//
//  viewMyPhotos.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/4/23.
//

import UIKit

private let reuseIdentifier = "Cell"

class viewMyPhotos: UICollectionViewController {

    var photoList: [ExcelentPhotos] = []
    var hrempid:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

   
        
        
        loadPhotos()
        // Do any additional setup after loading the view.
    }

    
    
    
    func loadPhotos(){
        
        
        self.view.makeToastActivity(.center)
        
        
        
        
        Task {
            
            do {
                
                photoList = try await JsonFetcher.fetchExcelentPhotosAsync(hrempid: hrempid)
                
                // Update collection view content
                self.collectionView.reloadData()
                
                //HUD.hide(true)
                self.view.hideToastActivity()
                
            } catch {
                print("Request failed with error: \(error)")
            }
            
        }
        
        
        
        
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! MyPhotosCell
        
        if let url = photoList[indexPath.row].MediaUrl {
            Task {
                
                do {
                    
                    let img = try await JsonFetcher.fetchPhotoAsync(urlStr: url)
                    cell.img.image = img
                    
                } catch {
                    print("Request failed with error: \(error)")
                }
            }
            
        }
        let actstr = "Account: " + (photoList[indexPath.row].AccountNumber ?? "")
            
            cell.lblAccounht.text = actstr
            
            cell.lblDate.text = photoList[indexPath.row].Date
        // Configure the cell
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           performSegue(withIdentifier: "showMyPhoto", sender: nil)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showMyPhoto" {
               if let indexPaths = collectionView.indexPathsForSelectedItems{
                   let destinationController = segue.destination as! viewMyPhoto
                   destinationController.TakenBy = photoList[indexPaths[0].row].AccountNumber
                   destinationController.TakenOn = photoList[indexPaths[0].row].Date
                   destinationController.Rating = photoList[indexPaths[0].row].MarketingGrade
                   destinationController.TakenBy = photoList[indexPaths[0].row].ProName
                   //destinationController.image.image = photoListImages[indexPaths[0].row]
                   destinationController.MediaUrl = photoList[indexPaths[0].row].MediaUrl
                   destinationController.Office1 = photoList[indexPaths[0].row].OfficeName
                   collectionView.deselectItem(at: indexPaths[0], animated: false)
               }
           }
        
        
        
        
       }
    
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
