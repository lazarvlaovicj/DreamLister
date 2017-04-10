//
//  ViewController.swift
//  DreamLister
//
//  Created by PRO on 4/8/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        testingItems()
        fetchAttempt()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let section = controller.sections {
            return section.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell {
            
            configCell(cell: cell, for: indexPath as NSIndexPath)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func configCell(cell: Cell, for indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.cellConfig(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objct = controller.fetchedObjects , objct.count > 0 {
            let item = objct[indexPath.row]
            performSegue(withIdentifier: "toEditVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC" {
            if let dest = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    dest.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func fetchAttempt() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            request.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            request.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            request.sortDescriptors = [titleSort]
        }
        
        
        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch {
            let error = error as NSError
            print(error)
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        fetchAttempt()
        tableView.reloadData()
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as? Cell
                configCell(cell: cell!, for: indexPath as NSIndexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    func testingItems() {
        
        let item = Item(context: context!)
        item.title = "New Macbook Pro"
        item.price = 1500
        item.details = "Can't wait to buy the newest Apple product!"
        
        let item2 = Item(context: context!)
        item2.title = "Apple Airpods"
        item2.price = 159
        item2.details = "Wireless Airpods will change the game."
        
        let item3 = Item(context: context!)
        item3.title = "Tesla Model S"
        item3.price = 80000
        item3.details = "One day i will own this car. Just watch me"
        
        
        ad?.saveContext()
    }
    
}

