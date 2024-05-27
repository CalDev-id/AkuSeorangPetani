//
//  PlacementSettings.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 16/05/24.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    //properti when user select a model
    @Published var selectedModel: Model? {
        willSet(newValue){
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    //when user tap confirm
    @Published var confirmedModel: Model? {
        willSet(newValue){
            guard let model = newValue else{
                print("Clearing confirmed model")
                return
            }
            print("Setting confirmedModel to \(model.name)")
        }
    }
    
    var sceneObserver:Cancellable?
}
