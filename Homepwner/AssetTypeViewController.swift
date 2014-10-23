//
//  AssetTypeViewController.swift
//  Homepwner
//
//  Created by Christian Keur on 10/6/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

class AssetTypeViewController: UITableViewController {
    var item: Item!
    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allAssetTypes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        
        let assetType = itemStore.allAssetTypes[indexPath.row]
        if let assetString = assetType.valueForKey("label") as? String {
            cell.textLabel.text = assetString
        }
        
        if assetType == item.assetType {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .Checkmark
            
            let assetType = itemStore.allAssetTypes[indexPath.row]
            item.assetType = assetType
        }
    }
}
