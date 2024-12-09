//
//  TableViewController.swift
//  MapVieww
//
//  Created by Aslan  on 22.11.2024.
//

import UIKit

class BuildingTableViewCell: UITableViewCell {
    @IBOutlet weak var buildingImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var namlabel: UILabel!
    
}

class TableViewController: UITableViewController {
    var arrayBuilding =
    [Building(name: "San Diego Zoo Safari Park", info: "4,5 ⭐️⭐️⭐️⭐️ 4 802 отзывов", lat: 33.0978621716, long: -116.9952774647, image: "zoo"),
    Building(name: "Disneyland Park in California", info: "4,7 ⭐️⭐️⭐️⭐️ 130 816 отзывов", lat: 33.812511, long: -117.918976, image: "park"),
    Building(name: "Chase Center", info: "4,7 ⭐️⭐️⭐️⭐️ 8 230 отзывов", lat: 37.768009, long: -122.387787, image: "chase"),
    Building(name: "Santa Monica State Beach", info: "0 ⭐️", lat: 34.010090, long: -118.496948, image: "beach")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayBuilding.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! BuildingTableViewCell
        let building = arrayBuilding[indexPath.row]

        // Настройка текста и изображения
        cell.infoLabel.text = building.info
        cell.buildingImageView.image = UIImage(named: building.image)
        cell.namlabel.text = building.name
        return cell // Не забудьте вернуть ячейку!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        vc.building = arrayBuilding[indexPath.row]
        
        navigationController?.show(vc, sender: self)
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
