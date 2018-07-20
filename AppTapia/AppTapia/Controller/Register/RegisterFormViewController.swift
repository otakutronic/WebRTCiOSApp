//
//  RegisterFormViewController.swift
//  AppTapia
//
//  Created by octto on 2017/12/07.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class RegisterFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    private func setupForm() {
        //Check https://github.com/xmartlabs/Eureka for the usage.
        //TODO: Remove hardcode tag.
        form +++ Section("User profile")
            
            <<< profilePictureRow
            <<< emailRow.onRowValidationChanged(formvalidationFeedback)
            <<< phoneRow
            <<< nameRow
            <<< genderRow
            
            +++ Section(header: "Passcode and Security question", footer: "Secret question and answer should be English")
            
            <<< passcodeRow
            <<< secretQuestionRow.onRowValidationChanged(formvalidationFeedback)
            <<< secretAnswerRow.onRowValidationChanged(formvalidationFeedback)
            
            +++ Section("")
            
            <<< ButtonRow() { row in
                row.title = "Register"
                row.tag = "register"
                }.onCellSelection({ [weak self] (cell, row) in
                    if self?.form.validate().count == 0 {
                        print("good")
                        self?.regisUser(from: (self?.form.values())!)
                    }
                })
    }
    
    //MARK: - Form rows
    
    private let profilePictureRow = ImageRow() { row in
        row.title = "Profile Picture"
        row.sourceTypes = [.All]
        row.tag = "profilepicture"
        }.cellUpdate { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    }
    
    private let emailRow = EmailRow() { row in
        row.title = "Email"
        row.placeholder = "email address"
        row.add(rule: RuleRequired())
        row.add(rule: RuleEmail())
        row.validationOptions = .validatesOnChangeAfterBlurred
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
    }
    
    private let phoneRow = PhoneRow() { row in
        row.title = "Phone number"
        row.placeholder = "phone number"
        row.tag = "phone"
    }
    
    private let nameRow = NameRow() { row in
        row.title = "Name"
        row.placeholder = "name"
        row.tag = "name"
    }
    
    private let genderRow = SegmentedRow<String>() { row in
        row.title = "Gender"
        row.options = ["♂️Male", "♀️Female", "others" ]
        row.value = "♂️Male"
        row.tag = "gender"
    }
    
    private let passcodeRow = ButtonRow() { row in
        row.title = "Set login passcode"
        row.tag = "passcode"
        //                row.presentationMode = .segueName(segueName: "go to passcode vc", onDismiss: nil)
    }
    
    private let secretQuestionRow = TextRow() { row in
        row.title = "Secret question"
        row.tag = "secretq"
        row.add(rule: RuleRequired())
    }
    
    private let secretAnswerRow = PasswordRow() { row in
        row.title = "Secret answer"
        row.tag = "secreta"
        row.add(rule: RuleRequired())
    }
    
    private let registerRow = ButtonRow() { row in
        row.title = "Register"
        row.tag = "register"
        }
    
    
    //MARK: - form validation closure
    private let formvalidationFeedback: ((BaseCell, BaseRow) -> Void) = { cell, row in
        let rowIndex = row.indexPath!.row
        while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            row.section?.remove(at: rowIndex + 1)
        }
        if !row.isValid {
            for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                let labelRow = LabelRow() {
                    $0.title = validationMsg
                    $0.cell.height = { 30 }
                }
                row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
            }
        }
    }
    
    //MARK: - Registration
    private func regisUser(from valueDict: Dictionary<String, Any?>) {
        
    }
    
    private func regisUser(username: String, secretQuestion: String, secretPassword: String, profilePicture: UIImage) {
        //DO register
    }
    
    //MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
