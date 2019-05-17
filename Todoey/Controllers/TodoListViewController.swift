//
//  ViewController.swift
//  Todoey
//
//  Created by Blake Joynez on 5/14/19.
//  Copyright © 2019 BJ. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  
  var selectedCategory: Category? {
    //LOADS items when value for category is set
    didSet{
      loadItems()
    }
  }
  
  let defaults = UserDefaults.standard
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //this is the singleton for app delwgate

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
  
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    
    
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    
    
    cell.accessoryType = item.done == true ? .checkmark : .none
    
   
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  //MARK - Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    print(itemArray[indexPath.row])

//    UPDATE ITEMS
//    itemArray[indexPath.row].setValue("Completed", forKey: "title")
    
    
//    context.delete(itemArray[indexPath.row])
//    itemArray.remove(at: indexPath.row)

    
//    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
      tableView.cellForRow(at: indexPath)?.accessoryType = .none

    }else{
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

    }
    
    saveItems()

    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //once user clicks this is what is going to happen
      if textField.text != "" {
        
        
        let newItem = Item(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        self.itemArray.append(newItem)
        
        self.saveItems()
        
      }
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Enter Todo item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  
  func saveItems() {
    
    do{
     try context.save()
    }catch{
      print("Error saving context, \(error)")
    }
    
    tableView.reloadData()
  }
  
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    }else{
      request.predicate = categoryPredicate
    }
    
    
    do{
      itemArray = try context.fetch(request)
    }catch{
      print("Error fetching data from context \(error)")
    }
  }
  
  
}

extension TodoListViewController: UISearchBarDelegate{
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.predicate = predicate
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request, predicate: predicate)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      
      // Main is where UI should  be updated
      DispatchQueue.main.async{
        searchBar.resignFirstResponder()

      }
    }
  }
}

