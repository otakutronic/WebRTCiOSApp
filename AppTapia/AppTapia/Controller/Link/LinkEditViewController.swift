//
//  LinkEditViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import MBProgressHUD

class LinkEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    var HUD: MBProgressHUD!
    var contact: Contact!

    /// viewDidLoad
    override func viewDidLoad() {
        
        print("LinkEditViewController")

        imagePicker.delegate = self

        nameTextField.text = contact.id
        nameTextField.delegate = self
        //nameTextField.becomeFirstResponder()

        if(contact.profilePicture != "") {
            let imageDecoded:UIImage = contact.decodeImage(stringImage: contact.profilePicture)
            contactImageView.image = imageDecoded
        }
    }
    
    /// textFieldDidBeginEditing
    ///
    /// - Parameter textField: <#textField description#>
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //saveButton.isEnabled = false
    }
    
    /// textFieldShouldReturn
    ///
    /// - Parameter textField: <#textField description#>
    /// - Returns: <#return value description#>
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        return true
    }
    
    /// cancelButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// saveButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // Save image
        if let imageData = UIImagePNGRepresentation(contactImageView.image!) {
            
            self.dismiss(animated: true, completion: nil)
            let imageEncoded = contact.encodeImage(uiImage: contactImageView.image!)
            
            // update contacts database
            let newContact = Contact(uuid: contact.id, name: contact.name, number: contact.number, state: contact.state, profilePicture: imageEncoded)
            LibraryAPI.shared.setContactData(newContact: newContact)

        } else {
            showWarningAlert(viewController: self, Message: "Get photo failed.", OkAction: nil)
        }
    }

    /// changeButtonClicked
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func changeButtonClicked(_ sender: Any) {
        print("changeButtonClicked")
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }

    /// UIImagePickerControllerDelegate Methods
    ///
    /// - Parameters:
    ///   - picker: <#picker description#>
    ///   - info: <#info description#>
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let resizedImage = resizeImage(image: pickedImage, newWidth: 240)
            contactImageView.clipsToBounds = true
            contactImageView.contentMode = .scaleAspectFill
            contactImageView.image = resizedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    /// imagePickerControllerDidCancel
    ///
    /// - Parameter picker: <#picker description#>
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /// resizeImage
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - newWidth: <#newWidth description#>
    /// - Returns: <#return value description#>
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
