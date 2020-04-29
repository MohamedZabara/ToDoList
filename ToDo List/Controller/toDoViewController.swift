//
//  ViewController.swift
//  ToDo List
//
//  Created by Mohamed Zabara on 3/19/20.
//  Copyright © 2020 Mohamed Zabara. All rights reserved.
//

import UIKit
import CoreData
class toDoViewController: UITableViewController {
    var itemArray = [Item]()
    var categorySelected : Category?{
        didSet{
            loadItem()
        }
    }
    //let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        loadItem()
        
    }
    
    //MARK: - Datasource delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath)
        let item = itemArray[indexPath.row]
        
        
        //ternary operator
        //value = condition ? valueOfTrue : valueOfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        cell.textLabel?.text = item.title
        return cell
    }
    
    //MARK: - Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Updating in coreData
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        //Delete data in coraData
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        //        tableView.reloadData()
        
        //        if itemArray[indexPath.row].done == true{
        //            itemArray[indexPath.row].done = false
        //        }else{
        //            itemArray[indexPath.row].done = true
        //
        //        }
        
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add Todo item list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.categorySelected 
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            // self.defaults.set(self.itemArray, forKey: "array")
            //refresh it after adding new item to the array to add new row
            //reload the row and section of tableview
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - CRUD
    func saveItem(){
        
        do{
            try context.save()
        } catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItem(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.category MATCHES %@", categorySelected!.category!)
        
        if let searchPredicate = predicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate,categoryPredicate])
            request.predicate=compoundPredicate
        }else{
            request.predicate =  categoryPredicate
        }
        
        
       
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error in fetching request \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}



extension toDoViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        //query for this request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //sorting data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request,predicate: predicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

