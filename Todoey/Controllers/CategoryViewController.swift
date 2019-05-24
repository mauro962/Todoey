//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mauro Farabegoli on 5/15/19.
//  Copyright © 2019 Mauro Farabegoli M. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    // Angela: categories = [Category]()
    //var categoryArray = [Category]()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // introduction to nil coalescing operator:
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // title: Titulo del UIALert
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        // what will happen when add is clicked
        // title: Nombre del boton de agregar
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
           // self.categoryArray.append(newCategory) - Not necessary because of auto updating in Realm
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Category"
        //placeholder: texto que aparece en el espacio para escribir la nueva categoria
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        func loadCategories() {
        
            categoryArray = realm.objects(Category.self)
            
            tableView.reloadData()
    }
    
    
    
    
    
    
    
    
}
