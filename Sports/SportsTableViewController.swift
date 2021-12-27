//
//  SportsTableViewController.swift
//  Sports
//
//  Created by administrator on 26/12/2021.
//

import UIKit
import CoreData

class SportsTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sports = [Sport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllSports()
    }

    // MARK: - Table view data sourc

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportCell", for: indexPath) as! SportTableViewCell

        // Configure the cell...
        cell.sportLabel.text = sports[indexPath.row].sport
        if let image =  sports[indexPath.row].image {
            cell.sportImage.image = UIImage(data: image)
        }
        cell.imagesDelegates = self
        cell.index = indexPath.row

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPlayers", sender: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let item = sports[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Sport", message: nil, preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.text = item.sport
        }
        
        let updateAction = UIAlertAction(title: "Update", style: .default) {
            [weak alert] _  in
            guard let textField = alert?.textFields else {return}
            if let sport = textField[0].text{
                self.updateSport(sport: sport, at: indexPath.row)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSport(at: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playersVC = segue.destination as! PlayersTableViewController
        playersVC.sport = sports[sender as! Int]
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
    
    // read
    func fetchAllSports(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sport")
        
        do {
            let result = try context.fetch(request)
            sports = result as! [Sport]
            tableView.reloadData()
            print("fetched")
        } catch {
            print("fetching error : \(error)")
        }
    }
    
    // create
    func addNewSport(inputSport: String){
        if !inputSport.isEmpty {
            let newSport = Sport(context: context)
            newSport.sport = inputSport
            if saveChanges() {
                sports.append(newSport)
                tableView.reloadData()
            }
        }
    }
    
    // update
    func updateSport(sport: String, at index: Int){
        let item = sports[index]
        item.sport = sport
        if saveChanges() {
            sports[index] = item
            tableView.reloadData()
        }
    }
    func updateImage(image: Data, at index: Int){
        let item = sports[index]
        item.image = image
        if saveChanges() {
            sports[index] = item
            tableView.reloadData()
        }
    }
    
    // delete
    func deleteSport(at index: Int){
        let item = sports[index]
        context.delete(item)
        if saveChanges() {
            sports.remove(at: index)
            tableView.reloadData()
        }
    }

    @IBAction func addNewSportButtenPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"Add New Sport", message: nil, preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "Sport"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) {
            [weak alert] _  in
            guard let textField = alert?.textFields else {return}
            if let sport = textField[0].text{
                self.addNewSport(inputSport: sport)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension SportsTableViewController: ImagesDelegates{
    
    func addImage(image: UIImage, at index: Int) {
        let newImage = image.jpegData(compressionQuality: 1.0)
        updateImage(image: newImage!, at: index)
    }
    
}
