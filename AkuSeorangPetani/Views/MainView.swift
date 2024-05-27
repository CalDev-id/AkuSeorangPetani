//
//  ContentView.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 15/05/24.
//

import SwiftUI
import RealityKit
import SceneKit
import CoreMotion
import Combine
import AVFoundation
import ARKit

struct MainView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings2: SessionSettings
    @State private var isControlsVisible:Bool = true
    @State private var showBrowse:Bool = false
    @State private var showSettings:Bool = false
    @State private var isPlay:Bool = false
    @State private var isTool:Bool = false
    
    var moveToLocation: Transform = Transform()
    var tigerEntity: ModelEntity?
    
//    func music(){
//        var player: AVAudioPlayer!
//        
//        let url = Bundle.main.url(forResource: "lagu", withExtension: "mp3")
//        
//        // do nothing if this url is empty
//        guard url != nil else {
//            return
//        }
//        
//        do {
//            player = try AVAudioPlayer(contentsOf: url!)
//            player.play()
//            print("ini bisa njir")
//        } catch {
//            print("\(error)")
//        }
//    }
    init(){
        playOP(name: "laguOP", extensionFile: "mp3")
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(isTool: $isTool)
            VStack{
                Spacer()
                Image("groundbg2")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 700)
                    .ignoresSafeArea()
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Image("grassLogo").resizable().frame(width: 70, height: 70)
                            .cornerRadius(100)
                            .padding()
                            .onTapGesture {
                                isTool.toggle()
//                                print("ayam")
//                                print(isTool)
                                if isTool {
                                    let model = Model(name: "ganyu", category: .furniture, scaleCompensation: 100/100)
                                    model.asyncloadmodel()
                                    self.placementSettings.confirmedModel = model
                                }
                            }
                        Image("spongeLogo").resizable().frame(width: 70, height: 70)
                            .cornerRadius(100)
                            .padding()
                    }
                }
                Spacer()
            }
            if self.placementSettings.selectedModel == nil {
                ControlView(isControlsVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings:$showSettings)
            }else{
                PlacementView()
            }
            if(!isPlay){
                ZStack{
                    Image("bgHome2").resizable()
                        .scaledToFit()
                    VStack{
                        Spacer()
                            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        Image("logoarfarm")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 210)
                        Spacer()
                    }
//                    PlayerView(videoName: "liveWP", videoType: "mp4")
//                                    .edgesIgnoringSafeArea(.all)
//                                VideoManager(videoName: "liveWP")
//                    VStack{
//                        Spacer()
//                        Image("bgHome2")
//                            .resizable()
//                            .frame(maxWidth: .infinity, maxHeight: 700)
//                            .ignoresSafeArea()
//                    }
                    VStack{
                        Spacer()
                        ControlButton3(systemIconName: "play.fill", isOn: $sessionSettings2.isPeopleOcclusionEnabled, isPlay: $isPlay, objectOcc: $sessionSettings2.isObjectOcclusionEnabled)
                            .padding(.bottom, 24)
                            .padding(.top, 100)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.white)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable{
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    @Binding var isTool: Bool
    
//    func makeUIView(context: Context) -> ARView {
//        
//        let arView = ARView(frame: .zero)
//
//        let model = try! ModelEntity.loadModel(named: "ganyu")
//        if model.availableAnimations {
//            model.anima
//        }
//
//        // Create horizontal plane anchor for the content
////        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//        let anchor = AnchorEntity(.image(group: "ARResources", name: "CoffeeLogo"))
//        anchor.children.append(model)
//
//        // Add the horizontal plane anchor to the scene
//        arView.scene.anchors.append(anchor)
//
//        return arView
//        
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {

        
//        if isTool {
//            let arView = ARView(frame: .zero)
//            
//            guard let model = try? ModelEntity.loadModel(named: "ganyu") else {
//                fatalError("Failed to load model")
//            }
//            
//            // Create horizontal plane anchor for the content
////            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//            let anchor = AnchorEntity(.image(group: "ARResources", name: "CoffeeLogo"))
//            anchor.children.append(model)
//            
//            // Add the horizontal plane anchor to the scene
//            arView.scene.anchors.append(anchor)
//            return arView
//        }
        
        let arView2 = CustomARView(frame: .zero, sessionSettings: sessionSettings)
        
        // Subscribe to placement
        self.placementSettings.sceneObserver = arView2.scene.subscribe(to: SceneEvents.Update.self) { event in
            // Call update scene method
            self.updateScene(for: arView2, isTool: isTool)
        }
        
        guard let model = try? ModelEntity.loadModel(named: "house") else {
            fatalError("Failed to load model")
        }
        

        // Create horizontal plane anchor for the content
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//        let anchor = AnchorEntity(.image(group: "ARResources", name: "CoffeeLogo"))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView2.scene.anchors.append(anchor)
        
        return arView2


    }
    func updateUIView(_ uiView: UIView, context: Context) {}

    
    private func updateScene(for arView: CustomARView, isTool: Bool){
        
        //only display focusentity when the user selected when placement
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        //add model to scene if confirmed
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            self.place(modelEntity, in: arView, isTool: isTool)
            
            self.placementSettings.confirmedModel = nil
        }
    }
//    func modelAction(){
//        let randNum = Int.random(in: 1 ... 4)
//        var movement = moveEntity(direction: "forward")
////        tigerEntity?.playAudio(tigerAudio!)
//        
//        self.scene.publisher(for: AnimationEvents.PlaybackCompleted.self)
//            .filter{ $0.playbackController == movement }
//            .sink(receiveValue: { event in
////                movement = self.moveEntity(direction: "back")
//                switch randNum {
//                    case 1:
//                        movement = self.moveEntity(direction: "forward")
//                    case 2:
//                        movement = self.moveEntity(direction: "back")
//                    case 3:
//                        movement = self.moveEntity(direction: "left")
//                    case 4:
//                        movement = self.moveEntity(direction: "right")
//                    default:
//                        print("error")
//                }
//                self.modelAction()
//            })
//    }
    
    func moveEntity(direction: String) -> AnimationPlaybackController{
        var moveToLocation: Transform = Transform()
        var tigerEntity: ModelEntity?
        
        var movement: AnimationPlaybackController!
        
        let randomAudio = Int.random(in: 0 ... 2)
        
//        if randomAudio == 0 {
//            tigerEntity?.playAudio(tigerAudio!)
//        }else if randomAudio == 1{
//            tigerEntity?.playAudio(tigerAudio2!)
//        }else{
//            tigerEntity?.playAudio(combinedFootstepAudio!)
//            
//        }
        
        
        switch direction{
        case "forward":
//            ini maju kedepan. translation itu buat kasih tau kalo maju kedepan nambahin vector z nya 20
            moveToLocation.translation = (tigerEntity?.transform.translation)! + simd_float3(x: 0, y: 0, z: 100)
            movement = tigerEntity?.move(to: moveToLocation, relativeTo: tigerEntity, duration: 5)
            
            print("gerak depan")
            
//            nambahin animasi jalan kalo bisa wkwk
        
        case "back":
            let rotateAngle = simd_quatf(angle: GLKMathDegreesToRadians(180), axis: SIMD3(x: 0, y: 1, z: 0))
//            tigerEntity?.setOrientation(rotateAngle, relativeTo: tigerEntity)
            
            var rotationTransform = tigerEntity?.transform
            rotationTransform?.rotation = rotateAngle
            movement = tigerEntity?.move(to: rotationTransform!, relativeTo: tigerEntity?.parent, duration: 5)
            
//            moveToLocation.translation = (tigerEntity?.transform.translation)! + simd_float3(x: 0, y: 0, z: 100)
//            movement = tigerEntity?.move(to: moveToLocation, relativeTo: tigerEntity, duration: 5)
            
            print("gerak belakang")
            
        case "left":
            let rotateAngle = simd_quatf(angle: GLKMathDegreesToRadians(90), axis: SIMD3(x: 0, y: 1, z: 0))
//            tigerEntity?.setOrientation(rotateAngle, relativeTo: tigerEntity)
            
            var rotationTransform = tigerEntity?.transform
            rotationTransform?.rotation = rotateAngle
            movement = tigerEntity?.move(to: rotationTransform!, relativeTo: tigerEntity?.parent, duration: 5)
            
//            moveToLocation.translation = (tigerEntity?.transform.translation)! + simd_float3(x: 0, y: 0, z: 100)
//            movement = tigerEntity?.move(to: moveToLocation, relativeTo: tigerEntity, duration: 5)
            
            print("gerak kiri")
            
        case "right":
            let rotateAngle = simd_quatf(angle: GLKMathDegreesToRadians(-90), axis: SIMD3(x: 0, y: 1, z: 0))
//            tigerEntity?.setOrientation(rotateAngle, relativeTo: tigerEntity)
            
            var rotationTransform = tigerEntity?.transform
            rotationTransform?.rotation = rotateAngle
            movement = tigerEntity?.move(to: rotationTransform!, relativeTo: tigerEntity?.parent, duration: 5)
            
//            moveToLocation.translation = (tigerEntity?.transform.translation)! + simd_float3(x: 0, y: 0, z: 100)
//            movement = tigerEntity?.move(to: moveToLocation, relativeTo: tigerEntity, duration: 5)
            
            print("gerak kanan")
        default:
            print("Ga gerak mas")
        }
        
        return movement
    }
    
    private func place(_ modelEntity: ModelEntity, in arView:ARView, isTool: Bool){
        
        //clone modelentity
        let clonedEntity = modelEntity.clone(recursive: true)
        //enable translation
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
//        var anchorEntity: AnchorEntity
//        if isTool {
//            anchorEntity = AnchorEntity(.image(group: "ARResources", name: "CoffeeLogo"))
//            anchorEntity.addChild(modelEntity)
//            print("anchor detected")
//
//        } else {
//            anchorEntity = AnchorEntity(plane: .any)
//            print("anchor bebas")
//            anchorEntity.addChild(clonedEntity)
//        }
//        
        let anchorEntity = AnchorEntity(plane: .any)

        //create anchor
        anchorEntity.addChild(clonedEntity)
        
        
//        var audioPlayer: AVAudioPlayer?
//
//        do {
//            if let audioURL = Bundle.main.url(forResource: "farmSound", withExtension: "mp3") {
//                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
////                audioPlayer?.prepareToPlay()
//                audioPlayer?.play()
//                print("menyala abangku")
//
//            } else {
//                print("Audio file not found.")
//            }
//        } catch {
//            print("Failed to load audio file: \(error.localizedDescription)")
//        }

        
        if let entityAnimation = clonedEntity.availableAnimations.first{
//            play animation
            clonedEntity.playAnimation(entityAnimation.repeat(), transitionDuration: 5, startsPaused: false)
        }
        playSound(name: "farmSound", extensionFile: "mp3")
        //add anchor to scene
        arView.scene.addAnchor(anchorEntity)
        print("added model to entity")
        
    }
    
//    func loadAudio(){
//
//        
//    }

}

//#Preview {
//    ContentView()
//        .environmentObject(PlacementSettings())
//        .environmentObject(SessionSettings())
//}

struct ControlButton3: View {
    let systemIconName: String
    @Binding var isOn: Bool
    @Binding var isPlay: Bool
    @Binding var objectOcc: Bool

    var body: some View {
        Button(action: {
            self.isOn.toggle()
            self.isPlay.toggle()
            self.objectOcc.toggle()
            print("berhasil")
            stopOP()
        }){
            Image("PlayBtn2")
                .resizable()
                .frame(maxWidth: 300, maxHeight: 250)
                .buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}
