//
//  HomeViewController.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import UIKit
import SwiftyJSON
class HomeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UITextField!
    
    private var popupViewController: CallPopupViewController!
    
    /// viewDidLoad
    override func viewDidLoad() {
        
        //setPhotoAndName()
        
        print("createRemoteConnection on load")
        let barViewControllers = self.tabBarController?.viewControllers
        print("name: \(DataManager.currentUser)")
        
        print("barViewControllers: \(barViewControllers?.description)")
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        // Handle the text field’s user input through delegate callbacks.
        //nameLabel.delegate = self
        
        createRemoteConnection()
    }
    
    /// viewWillAppear
    ///
    /// - Parameter animated: <#animated description#>
    override func viewWillAppear(_ animated: Bool) {
        //setPhotoAndName()
    }
    
    /// setPhotoAndName
    func setPhotoAndName() {
        let myData:User = DataManager.currentUser
        
        if myData.profilePicture != "" {
            if let dataDecoded = Data(base64Encoded: myData.profilePicture) {
                if let decodedimage:UIImage = UIImage(data: dataDecoded) {
                    photoImageView.image = decodedimage
                }
            }
        }
        
        nameLabel.text = myData.name
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
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
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameLabel.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    /// showCallPopup
    ///
    /// - Parameters:
    ///   - contact: <#contact description#>
    ///   - sessionID: <#sessionID description#>
    func showCallPopup(contact: Contact, sessionID: String) {
        
        let storyboard = UIStoryboard(name: "CallPopup", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CallPopupViewID")
        self.popupViewController = vc.childViewControllers.first as! CallPopupViewController
        self.popupViewController.contact = contact
        self.popupViewController.sessionID = sessionID
        self.present(vc, animated: true, completion: nil)
    }
    
    /// closeCallPopup
    func closeCallPopup() {
        if let vc = self.popupViewController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    /// createRemoteConnection
    func createRemoteConnection() {
        
        LibraryAPI.shared.createRemoteConnection() {
            (responseString: String, responseData: [AnyObject]) in
            
            print("HomeViewController responseString: \(responseString)")
            
            if (responseString == SOCKETIO_EVENT_CALL_INCOMING_TAG) {
                
                let dataObject = JSON(responseData)[0]
                print("--------------------- dataObject: \(dataObject)")
                
                let sessionID = JSON(responseData)[0].stringValue
                let linkID = JSON(responseData)[1].stringValue
                let type = JSON(responseData)[2].stringValue
                
                print("sessionID: \(sessionID)")
                print("linkID: \(linkID)")
                print("type: \(type)")
                
                // show calling screen
                let contact = Contact(uuid: linkID, name: "", number: "", state: "call", profilePicture: "")
                self.showCallPopup(contact: contact, sessionID: sessionID)
                
            } else if(responseString == SOCKETIO_EVENT_CALL_CANCELLED_TAG) {
                
                self.closeCallPopup()
                
            } else if(responseString == SOCKETIO_EVENT_CALL_REQUEST_RECEIVED_SUCCESS_TAG) {
                
            }
        }
    }
}

