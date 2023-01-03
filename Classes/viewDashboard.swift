//
//  viewDashboard.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/21/22.
//

import UIKit

class viewDashboard: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var cvPhotos: UICollectionView!
    //@IBOutlet var cvSales: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //cvSales.delegate = self
        //cvSales.dataSource = self
        cvPhotos.delegate = self
        cvPhotos.dataSource = self
       
        cvPhotos.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            
            return 10
            
        
        
      
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
            //cell.layer.borderColor = UIColor.blue.cgColor
            //cell.layer.borderWidth = 1
            //cell.layer.cornerRadius = 4
        let img = UIImage(named: "gbtest")
            print(img?.size.width as Any)
            cell.imgThumb.image = img
            return cell
        
        
        

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
