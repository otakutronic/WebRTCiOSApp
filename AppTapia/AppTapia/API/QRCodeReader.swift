//
//  QRCodeReader.swift
//  AppTapia
//
//  Created by Andy 01/12/17.
//

import Foundation
import UIKit
import SwiftyJSON
import PhoneNumberKit
import RealmSwift
import AVFoundation
import MBProgressHUD

public enum QRCodeReaderState {
    case bad_code
    case ok_code
}

/// QRCodeReader
public protocol QRCodeReaderDelegate: class {
    func qrCodeReader(reader : QRCodeReader, state: QRCodeReaderState, val: String)
}

public extension QRCodeReaderDelegate {
    // add default implementation to extension for optional methods
    
    func qrCodeReader(reader : QRCodeReader, state: QRCodeReaderState, val: String) {
        
    }
}

public class QRCodeReader: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var avCaptureDeviceInput :AVCaptureDeviceInput?
    
    public weak var delegate: QRCodeReaderDelegate?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    /// initiate QR code reader
    ///
    /// - Parameter view: <#view description#>
    /// - Returns: <#return value description#>
    public func initReader(view: UIView) -> String {
        
        var setupResult:String = "SETUP_OK"
        
        if let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                avCaptureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            } catch {
                setupResult = "MESSAGE_LINK_NO_CAMERA_PERMISSION"
            }
            
        } else {
            setupResult = "MESSAGE_LINK_NO_CAMERA_DEVICE"
        }
        
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)

        switch (cameraAuthorizationStatus) {
            case .denied: break
            case .authorized:
                DispatchQueue.main.async {
                    setupResult = self.captureSession(view: view)
                }
                break
            case .restricted: break
            case .notDetermined:
                // Prompting user for the permission to use the camera.
                AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                    if granted {
                        print("Granted access to \(cameraMediaType)")
                        DispatchQueue.main.async {
                            setupResult = self.captureSession(view: view)
                        }
                    } else {
                        print("Denied access to \(cameraMediaType)")
                    }
                }
            }
        
        return setupResult
    }

    /// captureSession
    ///
    /// - Parameter view: <#view description#>
    /// - Returns: <#return value description#>
    private func captureSession(view: UIView) -> String {
        
        var sessionResult:String = "SETUP_OK"
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(avCaptureDeviceInput)
            
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
            self.start()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs
            sessionResult = error.localizedDescription
        }
        return sessionResult
    }

    /// start reader
    public func start() {
        self.captureSession?.startRunning()
    }
    
    /// stop reader
    public func stop() {
        self.captureSession?.stopRunning()
    }
    
    /// captureOutput
    ///
    /// - Parameters:
    ///   - captureOutput: <#captureOutput description#>
    ///   - metadataObjects: <#metadataObjects description#>
    ///   - connection: <#connection description#>
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            self.delegate?.qrCodeReader(reader: self, state: QRCodeReaderState.bad_code, val: "No barcode/QR code is detected")
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
                self.stop()
                self.delegate?.qrCodeReader(reader: self, state: QRCodeReaderState.ok_code, val: metadataObj.stringValue)
            }
        }
    }
}
