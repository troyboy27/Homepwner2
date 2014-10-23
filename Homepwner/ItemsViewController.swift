//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Christian Keur on 10/5/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    
    let itemStore: ItemStore
    let imageStore: ImageStore
    
    init(itemStore: ItemStore, imageStore: ImageStore) {
        self.itemStore = itemStore
        self.imageStore = imageStore
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Homepwner"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self,
            action: "addNewItem:")
        navigationItem.rightBarButtonItem = addItem
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the NIB file
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        // Register this NIB, which contains the cell
        tableView.registerNib(nib,
            forCellReuseIdentifier: "ItemCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: Actions
    
    @IBAction func addNewItem(sender: AnyObject) {
        // Create a new BNRItem and add it to the store
        let newItem = itemStore.createItem()
        // Figure out where that item is in the array
        if let index = find(itemStore.allItems, newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            // Insert this new row into the table.
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        }
    }
    
    // MARK: Table View Methods
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // Get a new or recycled cell
            let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",
                forIndexPath: indexPath) as ItemCell
            
            // Set the text on the cell with the description of the item
            // that is at the nth index of items, where n = row this cell
            // will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]
                
            // Configure the cell with the Item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            
            return cell
    }

    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            let dvc = DetailViewController(itemStore: itemStore, imageStore: imageStore)
            let item = itemStore.allItems[indexPath.row]
            dvc.item = item
            
            showViewController(dvc, sender: self)
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            // If the table view is asking to commit a delete command...
            if editingStyle == .Delete {
                let item = itemStore.allItems[indexPath.row]
                
                let title = "Delete \(item.name)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title,
                    message: message,
                    preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                        // Remove the item from the store
                        self.itemStore.removeItem(item)
                        
                        // Remove the item's image from the image store
                        self.imageStore.deleteImageForKey(item.itemKey)
                        
                        // Also remove that row from the table view with an animation
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                })
                ac.addAction(deleteAction)
                
                ac.modalPresentationStyle = .Popover
                
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    ac.popoverPresentationController?.sourceView = cell
                    ac.popoverPresentationController?.sourceRect = cell.bounds
                }
                
                presentViewController(ac, animated: true, completion: nil)
            }
    }
    
    override func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            // Update the model
            itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
}
