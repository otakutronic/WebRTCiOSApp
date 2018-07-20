//
//  RTCManager.swift
//  AppTapia
//
//  Created by Andy on 01/09/17.
//

import Foundation
import WebRTC

public enum RTCClientState {
    case disconnected
    case connecting
    case connected
}

public enum MsgFields: String {
    case answer = "answer"
    case offer = "offer"
    case candidate = "ice_candidate"
}

/// RTCManagerDelegate
public protocol RTCManagerDelegate: class {
    func rtcClient(client : RTCManager, type: String, startCallWithSdp sdp: String)
    func rtcClient(client : RTCManager, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack)
    func rtcClient(client : RTCManager, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack)
    func rtcClient(client : RTCManager, didReceiveError error: Error)
    func rtcClient(client : RTCManager, didChangeConnectionState connectionState: RTCIceConnectionState)
    func rtcClient(client : RTCManager, didChangeState state: RTCClientState)
    func rtcClient(client : RTCManager, didGenerateIceCandidate iceCandidate: RTCIceCandidate)
}

public extension RTCManagerDelegate {
    // add default implementation to extension for optional methods
    func rtcClient(client : RTCManager, didReceiveError error: Error) {
        
    }
    
    func rtcClient(client : RTCManager, didChangeConnectionState connectionState: RTCIceConnectionState) {
        
    }
    
    func rtcClient(client : RTCManager, didChangeState state: RTCClientState) {
        
    }
}

public class RTCManager: NSObject {
    
    fileprivate var iceServers: [RTCIceServer] = []
    fileprivate var peerConnection: RTCPeerConnection?
    fileprivate var connectionFactory: RTCPeerConnectionFactory = RTCPeerConnectionFactory()
    fileprivate var remoteIceCandidates: [RTCIceCandidate] = []
    fileprivate var isVideoCall = true
    
    var videoTrack: RTCVideoTrack?
    var audioTrack: RTCAudioTrack?
    
    public weak var delegate: RTCManagerDelegate?
    
    private var rtcInitiator:Bool = false
    
    fileprivate let audioCallConstraint = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio" : "true"],
                                                              optionalConstraints: nil)
    fileprivate let videoCallConstraint = RTCMediaConstraints(mandatoryConstraints: ["OfferToReceiveAudio" : "true", "OfferToReceiveVideo": "true"],
                                                              optionalConstraints: nil)
    var callConstraint : RTCMediaConstraints {
        return self.isVideoCall ? self.audioCallConstraint : self.videoCallConstraint
    }
    
    fileprivate let defaultConnectionConstraint = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: ["DtlsSrtpKeyAgreement": "true"])
    
    fileprivate var mediaConstraint: RTCMediaConstraints {
        let constraints = ["minWidth": "0", "minHeight": "0", "maxWidth" : "480", "maxHeight": "640"]
        return RTCMediaConstraints(mandatoryConstraints: constraints, optionalConstraints: nil)
    }
    
    private var state: RTCClientState = .connecting {
        didSet {
            self.delegate?.rtcClient(client: self, didChangeState: state)
        }
    }
    
    /// conveneience init
    convenience override init() {
        
        //iceServers your app wanna use
        var iceServers = Array<RTCIceServer>()
        
        let stun = RTCIceServer.init(urlStrings:[WEBRTC_STUN_URL])
        let turn = RTCIceServer(urlStrings: [WEBRTC_TURN_URL], username: WEBRTC_TURN_USERNAME, credential: WEBRTC_TURN_PASSWORD)
        
        iceServers.append(stun)
        iceServers.append(turn)
        
        self.init(iceServers: iceServers, videoCall: true)
    }
    
    /// init
    ///
    /// - Parameters:
    ///   - iceServers: <#iceServers description#>
    ///   - videoCall: <#videoCall description#>
    init(iceServers: [RTCIceServer], videoCall: Bool = true) {
        super.init()
        self.remoteIceCandidates = []
        self.iceServers = iceServers
        self.isVideoCall = videoCall
        self.configure()
    }
    
    deinit {
        guard let peerConnection = self.peerConnection else {
            return
        }
        if let stream = peerConnection.localStreams.first {
            peerConnection.remove(stream)
        }
    }
    
    /// configure
    public func configure() {
        initialisePeerConnectionFactory()
        //initialisePeerConnection()
    }
    
    /// initialisePeerConnectionFactory
    func initialisePeerConnectionFactory () {
        RTCPeerConnectionFactory.initialize()
        self.connectionFactory = RTCPeerConnectionFactory()
    }
    
    /// initialisePeerConnection
    func initialisePeerConnection () {
        let configuration = RTCConfiguration()
        configuration.iceServers = self.iceServers
        self.peerConnection = self.connectionFactory.peerConnection(with: configuration,
                                                                    constraints: self.defaultConnectionConstraint,
                                                                    delegate: self)
    }
    
    /// startConnection
    public func startConnection() {
        
        initialisePeerConnection ()
        
        guard let peerConnection = self.peerConnection else {
            return
        }
        
        self.state = .connecting
        let localStream = self.localStream()
        peerConnection.add(localStream)
        if let localVideoTrack = localStream.videoTracks.first {
            self.delegate?.rtcClient(client: self, didReceiveLocalVideoTrack: localVideoTrack)
        }
    }
    
    /// disconnect
    public func disconnect() {
        guard let peerConnection = self.peerConnection else {
            return
        }
        
        peerConnection.close()
        
        let factory = self.connectionFactory
        let localStream = factory.mediaStream(withStreamId: "RTCmS")
        //localStream.getTracks().forEach((t) => {
            //localStream.removeTrack(t);
        //});
        //localStream.release();
 
        let videoTrack = self.videoTrack
        localStream.removeVideoTrack(videoTrack!)
        
        let audioTrack = self.audioTrack
        localStream.removeAudioTrack(audioTrack!)
        
        if let stream = peerConnection.localStreams.first {
            peerConnection.remove(stream)
        }

        self.delegate?.rtcClient(client: self, didChangeState: .disconnected)
        
        self.remoteIceCandidates.removeAll()
    }
    
    /// Let's make it to the makeOffer function collectively
    // from creating PeerConnection to sending offer to the other party.
    public func makeOffer() {
        guard let peerConnection = self.peerConnection else {
            return
        }
    
        peerConnection.offer(for: self.callConstraint, completionHandler: { [weak self]  (sdp, error) in
            guard let weakself = self else { return }
            if let error = error {
                weakself.delegate?.rtcClient(client: weakself, didReceiveError: error)
            } else {
                weakself.handleSdpGenerated(type: MsgFields.offer.rawValue, sdpDescription: sdp)
            }
        })
    }
    
    /// handleAnswerReceived - set the answer you receive as the other party's SDP
    /// PeerConnection should already exist at this time
    ///
    /// - Parameter remoteSdp: <#remoteSdp description#>
    public func handleAnswerReceived(withRemoteSDP remoteSdp: String?) {
        guard let remoteSdp = remoteSdp else {
            return
        }
        
        print("remoteSdp :\(remoteSdp)")
        
        // Add remote description
        let sessionDescription = RTCSessionDescription.init(type: .answer, sdp: remoteSdp)
        self.peerConnection?.setRemoteDescription(sessionDescription, completionHandler: { [weak self] (error) in
            guard let weakself = self else { return }
            if let error = error {
                weakself.delegate?.rtcClient(client: weakself, didReceiveError: error)
            } else {
                weakself.handleRemoteDescriptionSet()
                weakself.state = .connected
                self?.rtcInitiator = true
            }
        })
    }
    
    /// createAnswerForOfferReceived is almost the same as setAnswer, but
    /// it Generates peerConnection and makes Call set up process when setRemoteDescription is successful
    ///
    /// - Parameter remoteSdp: <#remoteSdp description#>
    public func createAnswerForOfferReceived(withRemoteSDP remoteSdp: String?) {
        
        guard let remoteSdp = remoteSdp,
            let peerConnection = self.peerConnection else {
                return
        }

        // Add remote description
        let sessionDescription = RTCSessionDescription(type: .offer, sdp: remoteSdp)
        self.peerConnection?.setRemoteDescription(sessionDescription, completionHandler: { [weak self] (error) in
            guard let weakself = self else { return }
            if let error = error {
                weakself.delegate?.rtcClient(client: weakself, didReceiveError: error)
            } else {
                weakself.handleRemoteDescriptionSet()
                // create answer
                peerConnection.answer(for: weakself.callConstraint, completionHandler:
                    { (sdp, error) in
                        if let error = error {
                            weakself.delegate?.rtcClient(client: weakself, didReceiveError: error)
                        } else {
                            weakself.handleSdpGenerated(type: MsgFields.answer.rawValue, sdpDescription: sdp)
                            weakself.state = .connected
                            self?.rtcInitiator = false
                        }
                })
            }
        })
    }
    
    /// addIceCandidate
    ///
    /// - Parameter iceCandidate: <#iceCandidate description#>
    public func addIceCandidate(sdp: String, sdpMLineIndex: Int32, sdpMid: String) {
        
        let iceCandidate = RTCIceCandidate(sdp: sdp, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
        
        // Set ice candidate after setting remote description
        if self.peerConnection?.remoteDescription != nil {
            self.peerConnection?.add(iceCandidate)
        } else {
            self.remoteIceCandidates.append(iceCandidate)
        }
    }
    
    /// who started the chat
    ///
    /// - Returns: true if started
    public func isInitiator() -> Bool {
       return self.rtcInitiator
    }
}

/// error domain
public struct ErrorDomain {
    static let videoPermissionDenied = "Video permission denied"
    static let audioPermissionDenied = "Audio permission denied"
}


private extension RTCManager {
    func handleRemoteDescriptionSet() {
        for iceCandidate in self.remoteIceCandidates {
            self.peerConnection?.add(iceCandidate)
        }
        self.remoteIceCandidates = []
    }
    
    // Generate local stream and keep it live and add to new peer connection
    func localStream() -> RTCMediaStream {
        let factory = self.connectionFactory
        let localStream = factory.mediaStream(withStreamId: "RTCmS")
        
        if self.isVideoCall {
            if !AVCaptureState.isVideoDisabled {

                if let videoTrack = self.videoTrack {
                    localStream.addVideoTrack(videoTrack) // keep video track as var for performance
                } else {
                    let videoSource = factory.avFoundationVideoSource(with: self.mediaConstraint)
                    let videoTrack = factory.videoTrack(with: videoSource, trackId: "RTCvS0")
                    localStream.addVideoTrack(videoTrack)
                    self.videoTrack = videoTrack
                }
            } else {
                // show alert for video permission disabled
                let error = NSError.init(domain: ErrorDomain.videoPermissionDenied, code: 0, userInfo: nil)
                self.delegate?.rtcClient(client: self, didReceiveError: error)
            }
        }
        if !AVCaptureState.isAudioDisabled {
            
            if let audioTrack = self.audioTrack {
                localStream.addAudioTrack(audioTrack) // keep audio track as var for performance
            } else {
                let audioTrack = factory.audioTrack(withTrackId: "RTCaS0")
                localStream.addAudioTrack(audioTrack)
                self.audioTrack = audioTrack
            }
        } else {
            // show alert for audio permission disabled
            let error = NSError.init(domain: ErrorDomain.audioPermissionDenied, code: 0, userInfo: nil)
            self.delegate?.rtcClient(client: self, didReceiveError: error)
        }
        return localStream
    }

    /// handleSdpGenerated
    ///
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - sdpDescription: <#sdpDescription description#>
    func handleSdpGenerated(type: String, sdpDescription: RTCSessionDescription?) {
        
        guard let sdpDescription = sdpDescription  else {
            return
        }
        
        // set local description
        self.peerConnection?.setLocalDescription(sdpDescription, completionHandler: {[weak self] (error) in
            // issue in setting local description
            guard let weakself = self, let error = error else { return }
            weakself.delegate?.rtcClient(client: weakself, didReceiveError: error)
        })
        //  Signal to server to pass this sdp with for the session call
        self.delegate?.rtcClient(client: self, type: type, startCallWithSdp: sdpDescription.sdp)
    }
}

// MARK: - <#RTCPeerConnectionDelegate#>
extension RTCManager: RTCPeerConnectionDelegate {
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        if stream.videoTracks.count > 0 {
            self.delegate?.rtcClient(client: self, didReceiveRemoteVideoTrack: stream.videoTracks[0])
        }
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        
    }
    
    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        self.delegate?.rtcClient(client: self, didChangeConnectionState: newState)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        self.delegate?.rtcClient(client: self, didGenerateIceCandidate: candidate)
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        
    }
}
