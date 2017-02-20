//
//  ViewController.swift
//  FoodTracker
//
//  Created by Engineering on 1/22/17.
//  Copyright © 2017 Engineering. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let manager = CMMotionManager()
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var gyroRawX: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //Dismiss this picker if the user cancels
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // only allow pictures to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
 
        // set delegate
        imagePickerController.delegate = self
        
        // presents view controller defined by imagePickerController, animates presentation of pickerController, and does nothing special after completion
        present(imagePickerController, animated: true, completion: nil)
        
        /*
        // this line checks to see if this device actually has a camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            // Hide the keyboard
            nameTextField.resignFirstResponder()
            
            // UIImagePickerController is a view controller that allows a user to pick media from their photo library, take a picture or movie, and more. This line declares one.
            let imagePicker = UIImagePickerController()
            
            // sets delegate of imagePicker
            imagePicker.delegate = self
            
            // 
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        */
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates()
            
            gyroRawX.text = String(format:"%f", (manager.gyroData?.rotationRate.x)!)
            
            manager.stopGyroUpdates()
        }
        
    }

}

