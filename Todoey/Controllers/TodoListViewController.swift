
import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
  //   let defaults = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")  // convert  array of data into items.plist
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 



    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
         let request: NSFetchRequest<Item> = Item.fetchRequest()

        loadItems(with: request )
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items }
    }
    
    // searchBar.delegate =  self
    //MARK - Table view Datasource methods
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType =  item.done == true ? .checkmark : .none  //Ternary operator
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)  // for delete data from database/
        
        
        itemArray[indexPath.row].setValue("Completed", forKey: "title") // update data in database
        
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done // if we put not false, it becomes true and if we put not true, it becomes false.
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
       // print(itemArray[indexPath.row])
    }
    
    // MARK -  Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:  "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            // what will happen once the user clicks the add item button on UIAlert
            self.itemArray.append(newItem)
            self.saveItems()
          //  self.defaults.set(self.itemArray, forKey: "TodoListArray")  // don't add data in defaults. its not database. you can store small data like swicth on or off. not list of data.
            
            
            
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model manupulation methods
    func saveItems() {
                do{
                    try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
       // let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
       itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from Context \(error)")
        }
    }
    
    
    


}
//MARK - Search bar methods

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
       // print(searchBar.text)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with:  request)
        
         
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            
        }
    }
}
