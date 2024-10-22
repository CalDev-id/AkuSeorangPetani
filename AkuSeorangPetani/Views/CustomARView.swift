//
//  CustomARView.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 16/05/24.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity
import Combine

class CustomARView: ARView {
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiuserCancellable: AnyCancellable?

    required init(frame frameRect: CGRect, sessionSettings: SessionSettings) {
        self.sessionSettings = sessionSettings
        
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        self.initializeSettings()
        
        self.setupSubscribers()
    }
    
    required init(frame frameRect: CGRect){
        fatalError("init frame hasnt been implemented")
    }
    
    @objc required dynamic init?(coder decoder: NSCoder){
        fatalError("init coder: hasnt been implemented")
    }
    
    private func configure(){
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)
    }
    private func initializeSettings(){
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
        self.lidarDebugOcclusion(isEnabled: sessionSettings.isLidarDebugEnabled)
        self.multiuserOcclusion(isEnabled: sessionSettings.isMultiuserEnabled)
    }
    private func setupSubscribers(){
        self.peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink{[weak self]
            isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        self.objectOcclusionCancellable = sessionSettings.$isObjectOcclusionEnabled.sink{[weak self]
            isEnabled in
            self?.updateObjectOcclusion(isEnabled: isEnabled)
        }
        self.lidarDebugCancellable = sessionSettings.$isLidarDebugEnabled.sink{[weak self]
            isEnabled in
            self?.lidarDebugOcclusion(isEnabled: isEnabled)
        }
        self.multiuserCancellable = sessionSettings.$isMultiuserEnabled.sink{[weak self]
            isEnabled in
            self?.multiuserOcclusion(isEnabled: isEnabled)
        }
    }
    private func updatePeopleOcclusion(isEnabled: Bool){
        print("people occ is now \(isEnabled)")
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else{
            return
        }
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        if configuration.frameSemantics.contains(.personSegmentationWithDepth){
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        }else{
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.session.run(configuration)
    }
    private func updateObjectOcclusion(isEnabled: Bool){
        print("object occ is now \(isEnabled)")
        
        if self.environment.sceneUnderstanding.options.contains(.occlusion) {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
    }
    private func lidarDebugOcclusion(isEnabled: Bool){
        print("lidar occ is now \(isEnabled)")
        
        if self.debugOptions.contains(.showSceneUnderstanding) {
            self.debugOptions.remove(.showSceneUnderstanding)
        } else {
            self.debugOptions.insert(.showSceneUnderstanding)
        }
    }
    private func multiuserOcclusion(isEnabled: Bool){
        print("multiuser occ is now \(isEnabled)")
        
        
    }
}


