//
//  PlayersTableViewController.swift
//  Sports and Players
//
//  Created by administrator on 29/10/2021.
//

import UIKit
import CoreData
class PlayersTableViewController: UITableViewController {
    var player = [Player]()
    var sport: Sports!
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(sport.sportName ?? "")"
    }

    // MARK: - Table view data source

    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Player", message: "Add a newPlayer", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
      alert.addTextField(configurationHandler: nil)
      alert.addTextField(configurationHandler: nil)

        let playerNametextField = alert.textFields![0]
        let playerAgetextField = alert.textFields![1]
        let playerHighttextField = alert.textFields![2]

        playerNametextField.placeholder = "Enter Name"
       playerAgetextField.placeholder = "Enter Age"
        playerHighttextField.placeholder = "Enter Hight"
                let saveAction = UIAlertAction(title: "Save", style: .default) {
                    _ in
                    let newplyer = Player(context: self.managedObjectContext)
                    newplyer.name = playerNametextField.text
                      newplyer.age = playerAgetextField.text
                      newplyer.hight = playerHighttextField.text
                    self.sport.addToPlayers(newplyer)
                    self.saveEntries()
                }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
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
        fetchBooks()
    }
    func fetchBooks() {
        do {
            player = try managedObjectContext.fetch(Player.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  sport.players!.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell")!
        let playerr = self.sport.players?[indexPath.row] as! Player
        cell.textLabel?.text = "\( playerr.name ?? "") -Age: \(playerr.age ?? ""),Height: \(playerr.hight ?? "")"
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(sport?.players?[indexPath.row] as! Player)
        
        self.saveEntries()
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
