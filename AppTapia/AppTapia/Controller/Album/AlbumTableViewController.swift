//
//  AlbumTableViewController.swift
//  tapiamobile
//
//  Created by Ta-Hsiung Hu on 2016/9/26.
//  Copyright © 2016年 com.mji.tapia. All rights reserved.
//

import UIKit
import AVFoundation
import QuickLook
import MBProgressHUD


class AlbumTableViewController: UITableViewController, AVCaptureMetadataOutputObjectsDelegate, QLPreviewControllerDataSource {

    
    @IBOutlet var photoTapiaImageView: UIImageView!
    @IBOutlet var subtitleTapiaLabel: UILabel!
    @IBOutlet var photoMonitoringImageView: UIImageView!
    @IBOutlet var subtitleMonitoringLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var HUD: MBProgressHUD!
    var isMonitoring = false
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var contact = Contact()
    var savedFile: NSURL!
    var downloadComplete = false
    
    var smallPictureTapia = UIImage(named: "account_circle_black")
    var pictureNumberTapia = 0
    var smallPictureMonitoring = UIImage(named: "account_circle_black")
    var pictureNumberMonitoring = 0
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    

    override func viewDidAppear(_ animated: Bool) {
        if downloadComplete {
            self.dismiss(animated: false, completion: nil)
        }
        //getPhotos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func scanQRCodeButtonClicked(_ sender: Any) {
        scanQRCode()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            isMonitoring = false
            self.performSegue(withIdentifier: "ShowAlbumDisplayCollectionViewController", sender: nil)
        } else if indexPath.section == 1 {
            isMonitoring = true
            self.performSegue(withIdentifier: "ShowAlbumDisplayCollectionViewController", sender: nil)
        }
    }

    
    // MARK: - Scan Small Photos
    func getPhotos() {
        HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("LOADING", comment: "")
        
        pictureNumberTapia = 0
        pictureNumberMonitoring = 0
        
        
        DispatchQueue.global().async {
            
            //tapia photos
            do {
                let filelist = try FileManager.default.contentsOfDirectory(atPath: "\(SMALL_PICTURE_FOLDER_TAPIA)/\(self.contact.number)/")
                
                for fileName in filelist {
                    if (fileName.hasSuffix("jpg")) || (fileName.hasSuffix("png")) || (fileName.hasSuffix("jpeg")){
                        self.pictureNumberTapia += 1
                        self.smallPictureTapia = UIImage(named: "\(SMALL_PICTURE_FOLDER_TAPIA)/\(self.contact.number)/\(fileName)")!
                    }
                }
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }

            // Monitoring photos
            do {
                let filelist = try FileManager.default.contentsOfDirectory(atPath: "\(SMALL_PICTURE_FOLDER_MONITORING)/\(self.contact.number)/")
                
                for fileName in filelist {
                    if (fileName.hasSuffix("jpg")) || (fileName.hasSuffix("png")) || (fileName.hasSuffix("jpeg")){
                        self.pictureNumberMonitoring += 1
                        self.smallPictureMonitoring = UIImage(named: "\(SMALL_PICTURE_FOLDER_MONITORING)/\(self.contact.number)/\(fileName)")!
                    }
                }
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }

            DispatchQueue.main.async(execute: {
                self.photoTapiaImageView.image = self.smallPictureTapia
                self.subtitleTapiaLabel.text = "\(self.pictureNumberTapia)枚"
                self.photoMonitoringImageView.image = self.smallPictureMonitoring
                self.subtitleMonitoringLabel.text = "\(self.pictureNumberMonitoring)枚"
                
                self.HUD.hide(animated: true)
            })
        }

    }
    
    
    
    
    // MARK: - Scan QRCode
    func scanQRCode() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            showWarningAlert(viewController: self, Message: "No barcode/QR code is detected", OkAction: nil)
            
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                print("QRCode:\(metadataObj.stringValue)")
                doAddQRCode(qrcode: metadataObj.stringValue)
            }
        }
    }
    
    
    // MARK: -  Do Add QRCode
    private func doAddQRCode(qrcode: String){
        HUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        HUD.mode = MBProgressHUDMode.indeterminate
        HUD.label.text = NSLocalizedString("DOWNLOADING", comment: "")
        
        

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: NSURL(string: qrcode)! as URL)
                
                if let getImage = UIImage(data: data) {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    self.savedFile = documentsURL.appendingPathComponent("/tapia_\(self.contact.number).png") as NSURL!
                    
                    let pngImageData = UIImagePNGRepresentation(getImage)
                    //                let jpgImageData = UIImageJPEGRepresentation(getImage, 1.0)   // if you want to save as JPEG
                    do {
                        try pngImageData!.write(to: URL(fileURLWithPath: self.savedFile.path!), options: .atomic)
                        if FileManager.default.fileExists(atPath: self.savedFile.path!) {
                            self.downloadComplete = true
                            let preview = QLPreviewController()
                            preview.dataSource = self
                            self.present(preview, animated: true, completion: nil)
                        } else {
                            showWarningAlert(viewController: self, Message: "Unable to preview data!", OkAction: nil)
                        }
                    } catch {
                        showWarningAlert(viewController: self, Message: error.localizedDescription, OkAction: nil)
                    }

                } else {
                    showWarningAlert(viewController: self, Message: "Download photo failed.", OkAction: nil)
                }
                
            } catch {
                print("")
            }
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.HUD.hide(animated: true)
            })
            
        }

    }

    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return savedFile
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if (segue.identifier == "ShowAlbumDisplayCollectionViewController") {
            let displayTVC = segue.destination as! AlbumDisplayCollectionViewController
            displayTVC.contact = contact
            displayTVC.isMonitoring = isMonitoring
        }*/
    }


}
