//
//  DetailViewController.swift
//  Homepwner
//
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialNumberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var assetTypeButton: UIBarButtonItem!
    
    let itemStore: ItemStore
    let imageStore: ImageStore
    
    var item: Item? {
        didSet {
            navigationItem.title = item?.name
        }
    }

    init(itemStore: ItemStore, imageStore: ImageStore) {
        self.itemStore = itemStore
        self.imageStore = imageStore
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("User init(itemStore:)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear first responder
        view.endEditing(true)
        // "Save" changes to item
        item?.name = nameField.text
        item?.serialNumber = serialNumberField.text
        
        let value = valueField.text.toInt() ?? 0
        println("Value is \(value)")
        
        let v2 = "95".toInt() ?? 0
        println("V2 is \(v2)")
        
        item?.valueInDollars = valueField.text.toInt() ?? 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item?.name
        serialNumberField.text = item?.serialNumber
        valueField.text = "\(item?.valueInDollars ?? 0)"
        
        if let date = item?.dateCreated {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .NoStyle
            
            dateLabel.text = dateFormatter.stringFromDate(date)
        }
        
        if let key = item?.itemKey {
            if let imageToDisplay = imageStore.imageForKey(key) {
                imageView.image = imageToDisplay
            }
        }
        
        if let typeLabel = item?.assetType?.valueForKey("label") as? String {
            assetTypeButton.title = typeLabel
        }
        else {
            assetTypeButton.title = "None"
        }
    }
    
    @IBAction func showAssetTypePicker(sender: AnyObject) {
        view.endEditing(true)
        
        let avc = AssetTypeViewController()
        avc.item = item
        avc.itemStore = itemStore
        
        showViewController(avc, sender: self)
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take a picture, otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        if let key = item?.itemKey {
            imageStore.setImage(image, forKey: key)
        }
        
        // Put that image onto the screen in our image view
        imageView.image = image
        
        // Take image picker off the screen -
        // you must call this dismiss method
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backgroundTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
