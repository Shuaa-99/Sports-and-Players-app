//
//  SportTableViewController.swift
//  Sports and Players
//
//  Created by administrator on 29/10/2021.
//

import UIKit
import CoreData
class YourCell : UITableViewCell,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var addimageButton: UIButton!
    
    @IBAction func addimgPress(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
//      present(picker, animated: true)
        self.window?.rootViewController?.present(picker, animated: true, completion: nil)
        
    }
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.editedImage] as? UIImage{
        addimageButton.setBackgroundImage(image, for: .normal)
        //setBackgroundImage(image, for: .normal)
//dismiss(animated: true)
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }else{
        print("image not found")
    }
}
}
class SportTableViewController: UITableViewController {
    
    @IBOutlet var mytableView: UITableView!
    
    

    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sport = [Sports]()
    
    var player: Player!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sports"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                fetchSport()
    }
    

    @IBAction func addSport(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Sport", message: "Add a new Sport", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let sportTextField = alert.textFields![0]
        
        sportTextField.placeholder = "Enter Sport"
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
  
            let newSport = Sports(context: self.managedObjectContext)
            newSport.sportName = sportTextField.text!
            self.saveEntries()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
    
    func saveEntries() {
        do {
            try managedObjectContext.save()
            print("Save successful")
        } catch {
            print("Error \(error)")
        }
        
                fetchSport()
    }
    
    func fetchSport() {
        do {
            sport = try managedObjectContext.fetch(Sports.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        mytableView.reloadData()
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return sport.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sport.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath)

        cell.textLabel!.text = sport[indexPath.row].sportName
       // cell.imageView?.image = UIImagePickerController
    
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  let sport = sport[indexPath.row]

            performSegue(withIdentifier:"ShowPlayerList", sender: sport)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowPlayerList" {
                let playerListTableViewController = segue.destination as! PlayersTableViewController
                playerListTableViewController.sport = sender as? Sports
                
            }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
       
     
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(sport[indexPath.row])
        self.saveEntries()
      //  if editingStyle == .delete {
            // Delete the row from the data source
           // tableView.deleteRows(at: [indexPath], with: .fade)
       // } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       // }
    }
    

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
