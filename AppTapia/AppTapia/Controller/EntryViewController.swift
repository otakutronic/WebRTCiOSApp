//
//  EntryViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import os.log

class EntryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // This value is either passed by `TapiaTableViewController` in `prepare(for:sender:)`
    // or constructed as part of adding a new tapia.
 
    var contact: Contact?
    
    /// <#Description#>
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Entry.
        if let contact = contact {
            navigationItem.title = contact.name
            nameTextField.text = contact.name
            //photoImageView.image = entry.photo
        }
        
        // Enable the Save button only if the text field has a valid Tapia name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    /// textFieldDidBeginEditing
    ///
    /// - Parameter textField: <#textField description#>
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    /// textFieldDidEndEditing
    ///
    /// - Parameter textField: <#textField description#>
    /// - Returns: <#return value description#>
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    /// <#Description#>
    ///
    /// - Parameter textField: <#textField description#>
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    /// imagePickerControllerDidCancel
    ///
    /// - Parameter picker: <#picker description#>
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    /// imagePickerController
    ///
    /// - Parameters:
    ///   - picker: <#picker description#>
    ///   - info: <#info description#>
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    /// cancel
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cancel(_ sender: UIBarButtonItem) {

        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddTapiaMode = presentingViewController is UINavigationController
        
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
            print("owningNavigationController")
        }
        else if isPresentingInAddTapiaMode || contact?.name == nil {
             dismiss(animated: true, completion: nil)
             print("isPresentingInAddTapiaMode")
        } else {
            fatalError("The EntryViewController is not inside a navigation controller.")
        }
    }
    
    /// This method lets you configure a view controller before it's presented.
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: <#sender description#>
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = navigationItem.title //nameTextField.text ?? ""
        //let photo = photoImageView.image
        
        // Set the meal to be passed to TapiaTableViewController after the unwind segue.
        contact = Contact(uuid: "0", name: name!, number: "", state: "", profilePicture: "")

    }
    
    //MARK: Actions
    /// selectImageFromPhotoLibrary
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    /// updateSaveButtonState
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

