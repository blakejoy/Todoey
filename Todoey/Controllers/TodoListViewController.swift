//
//  ViewController.swift
//  Todoey
//
//  Created by Blake Joynez on 5/14/19.
//  Copyright © 2019 BJ. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    
    print(dataFilePath)
    
    loadItems()
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
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
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
        
        let newItem = Item()
        newItem.title = textField.text!
        
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
    let encoder = PropertyListEncoder()
    
    do{
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    }catch{
      print("Error encoding item array, \(error)")
    }
    
    tableView.reloadData()
  }
  
  
  func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      do{
      itemArray = try decoder.decode([Item].self, from: data) //Specifiy data type
      }catch{
        print(error)
      }
    }
  }
  
}

