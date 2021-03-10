//
//  ItemTableViewController.swift
//  MyToDoListApp
//
//  Created by Luis Martínez Moreno on 2/2/21.
//

import UIKit

class ItemTableViewController: UITableViewController {
    var items  = [Item]()
    var defaults: UserDefaults {UserDefaults.standard}
    var allkeys: [String]{
        Array(defaults.dictionaryRepresentation().keys)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    /**
     Guarda el item que se le pasa por parametro
     */
    func saveItem(item: Item){
        do{
            let enc = JSONEncoder()
            let id = defaults.value(forKey: "idActual")
            enc.dateEncodingStrategy = .iso8601
            let item = try enc.encode(item)
            defaults.set(item, forKey: "\(id!)")
        }catch{
            print("problem while saving the data")
        }
    }
    /**
     Guarda las modificaciones realizadas sobre el item
     */
    func saveModification(info: Item){
        do{
            let enc = JSONEncoder()
            enc.dateEncodingStrategy = .iso8601
            let item = try enc.encode(info)
            defaults.set(item, forKey: "\(info.id)" )
        }catch{
            print("problem while saving the modifications")
        }
    }
    /**
     Imprime el array con todos los items
     */
    func printArr(){
        print("Items: ")
        for i in items{
            let salida = String(i.id)+" "+i.name
            print(salida)
        }
    }
    /**
     Carga el item que se le pasa por parametro
     */
    func loadItem(itemId:String){
        if let item = defaults.object(forKey: itemId) as? Data{
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let item = try? decoder.decode(Item.self,from: item){
                items.append( item)
            }else{
                print("Error while loading items")
            }
        }
    }
    /**
     Carga todos los items guardados
     */
    func loadData(){
        allkeys.forEach{key in
            loadItem(itemId: key)
        }
        sortByDate()
    }
    /**
     Organiza las tareas según su fecha
     */
    func sortByDate() {
        items = items.sorted {$0.date.compare($1.date) == .orderedAscending}
    }
    /**
     Realiza todas las tareas de borrado
     */
    func deleteItem(indexPath:IndexPath){
        let aux = items[indexPath.row]
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        defaults.removeObject(forKey: String(aux.id))
    }
    /**
     Realiza todas las tareas de modificación de un elemento
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /**
     Devulve el número de items, funcion necesaria para que funcione la tableView
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    /**
     Crea y configura la celda
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
        // Configure the cell...
        let item = items[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: item.date)
        cell.nameLabel.text = item.name
        cell.dateLabel.text = formattedDate
        cell.imageItem.image = UIImage(data: item.imagen)
        return cell
    }
    /**
     Carga la tarea desde la ventana en la que se mete hasta la lista
     */
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        _ = sender.source as? ViewController
    }
    /**
     Realiza todo lo necesario para mantener la integridad de la información al borrar un item
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(indexPath: indexPath)
        } else if editingStyle == .insert {
        }
    }
    /**
     Prepara la transicion a la escena de modificacion/creacion de tarea
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailVC = segue.destination as! ViewController
            // Get the cell that generated this segue.
            detailVC.delegate = self
            if let selectedCell = sender as? ItemTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedItem = items[indexPath.row]
                detailVC.item = selectedItem
                detailVC.ip = indexPath
            }
        }
        else if segue.identifier == "AddItem" {
            let detailVC = segue.destination as! ViewController
            detailVC.delegate = self
        }
    }
}

extension ItemTableViewController: ItemAddDelegate{
    /**
     Realiza todas las tareas de añadir un item
     */
    func itemAdder(itemToAdd: Item) {
        var idUD=defaults.value(forKey: "idActual")
        if(idUD == nil)
        {
            idUD = 0
        }
        let idUD_Int = idUD as! Int
        itemToAdd.id = (idUD_Int + 1)
        defaults.set(idUD_Int+1,forKey: "idActual")
        let newIndexPath = NSIndexPath(row: items.count, section: 0)
        items.append(itemToAdd)
        sortByDate()
        tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
        saveItem(item: itemToAdd)
        tableView.reloadData()
        
    }
    /**
     Realiza todas las tareas de modificar un item
     */
    func itemModifyer(item:Item, path:IndexPath) {
        let auxId = items[path.row].id
        item.id = auxId
        items[path.row] = item
        saveModification(info: items[path.row])
        sortByDate()
        tableView.reloadData()
    }
}
