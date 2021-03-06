
//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Blake Joynez on 5/17/19.
//  Copyright © 2019 BJ. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
  
  var categories = [Category]()

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //this is the singleton for app delwgate

    override func viewDidLoad() {
        super.viewDidLoad()

     loadCategories()
    }

  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell  = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categories[indexPath.row].name
    
    return cell
  }
  //MARK: - Data Manipulation Methods
  func loadCategories() {
    let request : NSFetchRequest<Category> = Category.fetchRequest()
    do{
    categories = try context.fetch(request)
    }catch{
      print("Error loading categories")
    }
    
    tableView.reloadData()
  }
  
  func saveCategories(){
    do{
      try context.save()
    }catch{
      print("Error saving")
    }
    
    tableView.reloadData()
  }

  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "" , preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      let newCategory = Category(context: self.context)
      
      newCategory.name = textField.text!
      
      self.categories.append(newCategory)
      
      self.saveCategories()
      
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Enter category name"
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow{
      destinationVC.selectedCategory = categories[indexPath.row]
    }
  }
  
  
  //MARK: - TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
}

