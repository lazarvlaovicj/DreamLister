//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by PRO on 4/9/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleName: CustomTextField!
    @IBOutlet weak var price: CustomTextField!
    @IBOutlet weak var details: CustomTextField!
    
    var stores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
//        let store = Store(context: context!)
//        store.name = "Best Buy"
//        let store2 = Store(context: context!)
//        store2.name = "Amazon"
//        let store3 = Store(context: context!)
//        store3.name = "AliExpress"
//        let store4 = Store(context: context!)
//        store4.name = "Ebay"
//        let store5 = Store(context: context!)
//        store5.name = "Apple"
//        let store6 = Store(context: context!)
//        store6.name = "BIG"
//        ad?.saveContext()
        
        fetchStores()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = stores[row]
        return row.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        code
    }
    
    func fetchStores() {
        let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            self.stores = try context!.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            //handle errors
        }
    
    }
    @IBAction func addItem(_ sender: Any) {
        
        let item = Item(context: context!)
        
        if let title = titleName.text {
            item.title = title
        }
        
        if let price = price.text {
            item.price = ((price as NSString).doubleValue)
        }
        
        if let details = details.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad?.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
}
