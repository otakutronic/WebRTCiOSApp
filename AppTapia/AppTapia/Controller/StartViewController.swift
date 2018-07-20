//
//  StartViewController.swift
//  AppTapia
//
//  Created by Andy 01/09/17.
//

import UIKit
import SwiftyJSON
import PhoneNumberKit

class StartViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var myActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setViewProcessing()
        //initialize()
        self.performSegue(withIdentifier: "PatternLockViewController", sender: nil)
    }

    //MARK: - Private methods
    
    /// setViewProcessing
    private func setViewProcessing() {
        myActivityIndicatorView.startAnimating()
    }

    /// setViewWait
    private func setViewWait(){
        myActivityIndicatorView.stopAnimating()
    }
    
    /// initialize and go to login screen if registered, go to register screen if not.
    private func initialize() {
        print("initialize...")
        LibraryAPI.shared.initialize(
            success: { [weak self] (responseData) in
                self?.goToLoginScreen()
            },
            failure: { [weak self] (errorMessage, responseData) in
                //User doesn't existed.
                self?.goToRegisterScreen()
            }
        )
    }
    
    /// request user contacts then go to login screen.
    private func goToLoginScreen() {
        let token:String = LibraryAPI.shared.appData.sessionToken
        LibraryAPI.shared.setUserContacts(token: token, completion: { [weak self] (responseString, responseData) in
            self?.setViewWait()
            self?.performSegue(withIdentifier: "PatternLockViewController", sender: nil)
        })
    }
    
    /// go to register screen.
    private func goToRegisterScreen() {
        setViewWait()
        self.performSegue(withIdentifier: "DescriptionViewController", sender: nil)
    }
    
    //MARK: - Deprecated method
    @available(*, deprecated)
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if let number = phoneNumberTextField.text {
            if number == "" {
                showWarningAlert(viewController: self, Message: NSLocalizedString("ERROR_MESSAGE_NO_PHONE_NUMBER", comment: "Phone number must has value"), OkAction: nil)
                return
            }
            
            do {
                let phoneNumber = try phoneNumberKit.parse(number, withRegion: "JP")
                let formattedNumber = phoneNumberKit.format(phoneNumber, toType: .international, withPrefix: true)
                print("formattedNumber:\(formattedNumber)")
                phoneNumberTextField.text = formattedNumber
                
                
            } catch {
                
            }
            
        }
    }

}
