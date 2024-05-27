//
//  ContentView.swift
//  AkuSeorangPetani
//
//  Created by Heical Chandra on 20/05/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    var body: some View {
        NavigationView{
            MainView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
        }
    }

}

//struct ARViewContainer: UIViewRepresentable {
//    
//    func makeUIView(context: Context) -> ARView {
//        
//        let arView = ARView(frame: .zero)
//
//        // Create a cube model
//        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//        let model = ModelEntity(mesh: mesh, materials: [material])
//        model.transform.translation.y = 0.05
//
//        // Create horizontal plane anchor for the content
//        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//        let anchor = AnchorEntity(.image(group: "Coba", name: "CoffeeLogo"))
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
//    
//}
//
//#Preview {
//    ContentView()
//}
