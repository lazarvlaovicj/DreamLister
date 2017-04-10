//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by PRO on 4/9/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleName: CustomTextField!
    @IBOutlet weak var price: CustomTextField!
    @IBOutlet weak var details: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!


    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

//        let store = Store(context: context!)
//        store.name = "Best Buy"
//        let store2 = Store(context: context!)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context!)
//        store3.name = "BIG"
//        let store4 = Store(context: context!)
//        store4.name = "AlliExpress"
//        let store5 = Store(context: context!)
//        store5.name = "Amazon"
//        let store6 = Store(context: context!)
//        store6.name = "Apple"
//                
//        ad!.saveContext()

        
        fetchStores()
        
        if itemToEdit != nil {
            editItem()
        }
        
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
        
        let item: Item!
        let image = Image(context: context!)
        image.image = thumbImg.image
        
        if itemToEdit == nil {
            item = Item(context: context!)
        } else {
            item = itemToEdit
        }
        
        item.toImage = image
        
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
    
    func editItem() {
        
        if let item = itemToEdit {
            
            titleName.text = item.title
            price.text = "\(item.price)"
            details.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = itemToEdit?.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
        }
        
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        
        if itemToEdit != nil {
            context?.delete(itemToEdit!)
        }
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func addImg(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
     
}
