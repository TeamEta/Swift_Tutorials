//
//  ViewController.swift
//  FoodTracker
//
//  Created by Engineering on 1/22/17.
//  Copyright © 2017 Engineering. All rights reserved.
//

import UIKit
import CoreMotion
import os.log
//import AVFoundation
import Photos

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let manager = CMMotionManager()
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gyroRawX: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var pictureTap: UITapGestureRecognizer!
    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    

    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
    
    //MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
        
        manager.stopDeviceMotionUpdates()
        
    }
    
    
    //MARK: Actions
    
    private let photoOutput = AVCapturePhotoOutput()
    
    //let tap = UITapGestureRecognizer(target: self, action: #selector(capturePhoto(_:)))
    
    @IBAction func capturePhoto(_ sender: UITapGestureRecognizer) {
        /*
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .auto
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.livePhotoMovieFileURL = nil
        if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        let photoCaptureDelegate = PhotoCaptureDelegate(with:photoSettings, format: photoSettings.previewPhotoFormat)
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureDelegate)*/
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            // Hide the keyboard
            nameTextField.resignFirstResponder()
            
            // UIImagePickerController is a view controller that allows a user to pick media from their photo library, take a picture or movie, and more. This line declares one.
            let imagePicker = UIImagePickerController()
            
            // sets delegate of imagePicker
            imagePicker.delegate = self
            
            //
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            
            self.present(imagePicker, animated: true, completion: nil)
            imagePicker.takePicture()
        }
    }
    
    
    
/*    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {

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
 
 
 
        // this line checks to see if this device actually has a camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            // Hide the keyboard
            nameTextField.resignFirstResponder()
            
            // UIImagePickerController is a view controller that allows a user to pick media from their photo library, take a picture or movie, and more. This line declares one.
            let imagePicker = UIImagePickerController()
            
            // sets delegate of imagePicker
            imagePicker.delegate = self
            
            // 
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            //imagePicker.takePicture()
            
            self.present(imagePicker, animated: true, completion: nil)
        }
 
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        /*
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.1
            manager.startGyroUpdates()
            
            gyroRawX.text = String(format:"%f", (manager.gyroData?.rotationRate.x)!)
            
            manager.stopGyroUpdates()
        }*/
        
        manager.deviceMotionUpdateInterval = 0.1
        manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler:
            {deviceManager, error in
                
                self.gyroRawX.text = String(format:"Yaw = %f", (self.manager.deviceMotion?.attitude.yaw)!)
            }
        )
        
    }
}

