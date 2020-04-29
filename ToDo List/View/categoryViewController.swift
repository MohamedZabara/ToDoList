//
//  categoryViewController.swift
//  ToDo List
//
//  Created by Mohamed Zabara on 3/23/20.
//  Copyright © 2020 Mohamed Zabara. All rights reserved.
//

import UIKit
import CoreData

class categoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categoryArray[indexPath.row].category

        return cell
    }
//MARK: - table view data delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! toDoViewController
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.categorySelected = categoryArray[indexPath!.row]
    }
    
    
    //MARK: - Add new category to the table view
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            self.categoryArray.append(newCategory)
            newCategory.category = textField.text!
            self.saveItem()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Category"
            textField = alertTextField
            
        }
        present(alert, animated: true)
    }
    
    //MARK: - DataManipulation
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("Error in addind data to corData\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(){
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do{
           categoryArray = try context.fetch(request)
        }catch{
            print("Error in fetching data\(error)")
        }
        
    }

}
