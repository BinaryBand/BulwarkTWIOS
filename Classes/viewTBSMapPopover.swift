//
//  viewTBSMapPopover.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 7/28/23.
//

import UIKit



protocol TBSMapToggleDelegate: AnyObject{
    func toggleMyLocation(isOn: Bool)
    func toggleWallLength(isOn: Bool)
    func toggleStationDist(isOn: Bool)
    func pressedTermiteDamage()
    func pressedConduciveCondition()
    func pressedActiveTermites()
    func pressedMudTubes()
    func pressedPreviousInfestation()
    func pressedEditHome()
    
    func pressedAddBaitStation()
    func pressedTrenching()
    func pressedAddDrillLoc()
    
}






class viewTBSMapPopover: UITableViewController {

    var myLocIsOn: Bool = false
    var wallLengthIsOn: Bool = false
    var StationDistanceIsOn: Bool = false
    
    static var delegate:TBSMapToggleDelegate?
    
    
    @IBOutlet var swMyLocation: UISwitch!
    
    @IBOutlet var swWallLength: UISwitch!
    
    @IBOutlet var swStationDist: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        swMyLocation.setOn(myLocIsOn, animated: false)
        swWallLength.setOn(wallLengthIsOn, animated: false)
        swStationDist.setOn(StationDistanceIsOn, animated: false)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //    return 0
    //}

   // override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
   //     return 0
   // }

    
    @IBAction func switchToggleMyLocation(_ sender: UISwitch) {
        viewTBSMapPopover.delegate?.toggleMyLocation(isOn: sender.isOn)
    }
    
    
    @IBAction func switchToggleWallLength(_ sender: UISwitch) {
        viewTBSMapPopover.delegate?.toggleWallLength(isOn: sender.isOn)
    }
    
    @IBAction func switchToggleStationDistance(_ sender: UISwitch) {
        viewTBSMapPopover.delegate?.toggleStationDist(isOn: sender.isOn)
    }
    
    @IBAction func btnDamagePress(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedTermiteDamage()
        dismiss(animated: true)
    }
    
    
    @IBAction func btnConducivePress(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedConduciveCondition()
        dismiss(animated: true)
    }
    
    
    
    @IBAction func btnActivePress(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedActiveTermites()
        dismiss(animated: true)
    }
    
    
    @IBAction func btnMudTubesPress(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedMudTubes()
        dismiss(animated: true)
    }
    
    @IBAction func btnPreviousInfestationPress(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedPreviousInfestation()
        dismiss(animated: true)
    }
    
    
    @IBAction func btnEditHomePress(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedEditHome()
        dismiss(animated: true)
    }
    
    
    @IBAction func btnAddBaitPressed(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedAddBaitStation()
        dismiss(animated: true)
        
    }
    
    @IBAction func btnAddTrenchingPressed(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedTrenching()
        dismiss(animated: true)
    }
    @IBAction func btnAddDrillPressed(_ sender: Any) {
        viewTBSMapPopover.delegate?.pressedAddDrillLoc()
        dismiss(animated: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
