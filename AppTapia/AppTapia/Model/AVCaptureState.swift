//
//  AVCaptureState.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import Foundation
import AVFoundation

class AVCaptureState {
    
    /// isVideoDisabled
    static var isVideoDisabled: Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        return status == .restricted || status == .denied
    }

    /// isAudioDisabled
    static var isAudioDisabled: Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        return status == .restricted || status == .denied
    }
}
