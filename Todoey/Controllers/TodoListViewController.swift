//
//  ViewController.swift
//  Todoey
//
//  Created by Mauro Farabegoli on 5/9/19.
//  Copyright © 2019 Mauro Farabegoli M. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"]
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        print(dataFilePath)
        
        
               
    loadItems()
        
       
    }

    //MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
      let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // introduction to ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item to List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when add is clicked
          
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Model manipulation methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
        
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            // try? means: do it if it's not an optional.
            let decoder = PropertyListDecoder()
            do {
           itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array, \(error)")
            }
        }
    }
    
    
    // [Item].self syntax explanation:
    
//    Initially, We created an instance of [Item] with: itemArray = [Item]()
//
//    So now, the datatype of itemArray is [Item]
//
//    Decode needs to know the datatype of the object it’s working with.
//    Simply writing [Item] would be ambiguous. Did you mean an instance or the datatype itself?
//    So, to refer to the datatype, we write [Item].self.

    
//    Optional Binding:
//    if let data = try? Data(contentsOf: dataFilePath!)
//
//    Data(contentsOf: dataFilePath!)  Gets the contents of a file at dataFilePath
//    and returns it as optional Data?  (actually a buffer area that can be nil)
//
//    try? is needed because the file might not be there (or some other error)
//
//    if let data  unwraps returned Data?  value if it is not nil.
    
    
    
}




