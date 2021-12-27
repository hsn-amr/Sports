//
//  PlayersTableViewController.swift
//  Sports
//
//  Created by administrator on 26/12/2021.
//

import UIKit

class PlayersTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sport : Sport?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = sport?.sport ?? "Players"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sport?.players?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)

        // Configure the cell...
        let item = sport?.players?[indexPath.row] as! Player
        if let name = item.name, let age = item.age, let height = item.height{
            cell.textLabel?.text = "\(name) - Age: \(age), Height: \(height)"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deletPlayert(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let item = sport?.players?[indexPath.row] as! Player
        let alert = UIAlertController(title: "Update Player", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = item.name
        })
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = item.age
        })
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = item.height
        })
        
        let updateAction = UIAlertAction(title: "Update", style: .default, handler: {
            [weak alert] _ in
            guard let textFields = alert?.textFields else {return}
            
            if let name = textFields[0].text,
               let age = textFields[1].text ,
               let height = textFields[2].text {
                self.updatePlayer(name: name, age: age, height: height, at: indexPath.row)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addNewPlayerButtenPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Player", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Name"
        })
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Age"
        })
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Height"
        })
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            [weak alert] _ in
            guard let textFields = alert?.textFields else {return}
            
            if let name = textFields[0].text,
               let age = textFields[1].text ,
               let height = textFields[2].text {
                self.addNewPlayer(name: name, age: age, height: height)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveChanges() -> Bool{
        var done = false
        if context.hasChanges {
            do {
                try context.save()
                print("saved")
                done = true
            } catch {
                print("saving error: \(error)")
            }
        }
        return done
    }
    
    
    // create
    func addNewPlayer(name: String, age: String, height: String){
        if !name.isEmpty && !age.isEmpty && !height.isEmpty{
            let newPlayer = Player(context: context)
            newPlayer.name = name
            newPlayer.age = age
            newPlayer.height = height
            
            sport?.addToPlayers(newPlayer)
            if saveChanges() {
                tableView.reloadData()
            }
        }
        
    }
    
    // update
    func updatePlayer(name: String, age: String, height: String, at index: Int){
        
        (sport?.players?[index] as! Player).name = name
        (sport?.players?[index] as! Player).age = age
        (sport?.players?[index] as! Player).height = height
        if saveChanges() {
            tableView.reloadData()
        }
    }
    
    // delete
    func deletPlayert(at index: Int){
        context.delete((sport?.players?[index] as! Player))
        if saveChanges() {
            tableView.reloadData()
        }
    }

}
