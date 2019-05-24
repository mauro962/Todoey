//
//  ViewController.swift
//  Todoey
//
//  Created by Mauro Farabegoli on 5/9/19.
//  Copyright © 2019 Mauro Farabegoli M. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"]
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory: Category? {
        didSet {
           loadItems()
        }
    }
    
//    So remember when we referred to the TodoListViewController, for example, we won't try to call its methods or grab its properties by calling the class.
//
//    Instead we need to get the object of delegate. So this would be the blueprint and we need to get the object that's created from the blueprint.
//
//    So this again is where our handy singletons come into use and instead of calling delegate I'm instead going to tap into UIApplication.shared
//
//    And this is a singleton app instance, and at the time point when our app is running live inside the user's iPhone then the shared UIApplication
//
//    will correspond to our live application object, and inside this shared UIApplication object is something called delegate and this is the delegate of
//
//    the app object (Alternatively known as the app delegate), and we're going to downcast it as our class delegate.
//
//    So we're tapping into the UIApplication class, We're getting the shared singleton object which corresponds to the current app as an object, then tapping
//
//    into its delegate, which has the data type of an optional UIApplication delegate.
//
//    We're casting it into our class app delegate because they both inherit from the same superclass, UIApplication Delegate.
//
//    This is perfectly valid and we now have access to our AppDelegate as an object.
//
//    So we're able to tap into its property code persistent container and we're going to grab the view context
//
//    of that persistent container so we can now say our context is this context.
    
    
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // let newItem = Item(context: context)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    //loadItems()
        
       
    }

    //MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // introduction to ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
        
    }

    
    //MARK - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                    // Si quisieramos borrar el item:
                    // realm.delete(item)
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
    //    Core Data: For deleting items: El orden de estas instrucciones es crucial para evitar errores
    //    context.delete(itemArray[indexPath.row])
    //    itemArray.remove(at: indexPath.row)
        
        
    //    todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
       // saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item to List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when add is clicked
         
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                  let newItem = Item()
                  newItem.title = textField.text!
                  currentCategory.items.append(newItem)
                  newItem.dateCreated = Date()
            }
                } catch {
                    print("Error Saving New Items, \(error)")
                }
            }

            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Model manipulation methods
    
//    func saveItems() {
//
//
//        do {
//          try context.save()
//        } catch {
//          print("Error saving context \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@" , selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate] )
////
////        request.predicate = compoundPredicate
//
//        do {
//          itemArray = try context.fetch(request)
//        } catch {
//          print("Error fetching data from context, \(error)")
//        }

        tableView.reloadData()
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

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    //print(searchBar.text!)
    
    //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
    
    //loadItems()
    }
//    let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//    // [cd] - c es por case , d es por diacritic (acentos, dieresis, etc) [cd] ocasiona que se ignoren esos criterios de comparacion.
//
//    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//    loadItems(with: request, predicate: predicate)

  

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}



