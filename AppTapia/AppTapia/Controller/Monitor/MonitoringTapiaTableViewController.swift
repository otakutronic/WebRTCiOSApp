//
//  MonitoringTapiaTableViewController.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/9/21.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import UIKit

class MonitoringTapiaTableViewController: MJITableViewController {

    var contactArray = Array<Contact>()
    var selectedContact = Contact()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("MonitoringTapiaTableViewController..................")
        
        // hide nav bars
        hideNav(leftItem: true, rightItem: true)
        
//        let nib = UINib(nibName: "MonitoringContactTableViewCell", bundle: nil)
//        self.tableView.register(nib, forCellReuseIdentifier: "MonitoringContactTableViewCell")
//        
//        //下拉刷新事件
//        self.refreshControl?.addTarget(self, action: #selector(MonitoringTapiaTableViewController.getContectList), for: UIControlEvents.valueChanged)
//        
//        definesPresentationContext = true
        
    }
    
    
    //override func viewWillAppear(_ animated: Bool) {
        //self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
        //self.refreshControl?.beginRefreshing()
        //getContectList()
    //}
    
    
    // MARK: - Table view data source
    //override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if UIDevice.current.userInterfaceIdiom == .phone {
           // return 60
        //}else {
          //  return 80
       // }
    //}

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.contactArray.count
    //}
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MonitoringContactTableViewCell") as! MonitoringContactTableViewCell
//        
//        var contact : Contact
//        contact = contactArray[indexPath.row]
//        
//        if contact.base64ProfilePicture != "" {
//            if let dataDecoded:Data = Data(base64Encoded: contact.base64ProfilePicture) {
//                if let decodedimage:UIImage = UIImage(data: dataDecoded) {
//                    cell.iconImageView.image = decodedimage
//                }
//            }
//        }
//        
//        cell.nameLabel.text = contact.name
//        
//        return cell
//    }
    
    //override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedContact = contactArray[indexPath.row]
        //self.performSegue(withIdentifier: "ShowMonitoringControlViewController", sender: nil)
    //}
    
    //override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //return true
    //}

    
    
    
    
    // MARK: - Get Contact List
    func getContectList(){
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        contactArray.removeAll()
//        let masterArray = ContactDao.sharedDao.getAllContactWithStatus(status: "8")    //Master
//        let subuserArray = ContactDao.sharedDao.getAllContactWithStatus(status: "7")    //Subuser
//
//        for contact in masterArray {
//            contactArray.append(contact)
//        }
//        for contact in subuserArray {
//            contactArray.append(contact)
//        }
//
//
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.tableView.reloadData()
//        })
//
//        self.refreshControl!.endRefreshing()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowMonitoringControlViewController") {
            let navigationController = segue.destination as! UINavigationController
            let monitoringControlVC = navigationController.topViewController as! MonitoringControlViewController
            monitoringControlVC.contact = selectedContact
            // monitoringControlVC.roomID =
        }
    }
}
