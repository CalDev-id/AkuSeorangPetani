//
//  Model.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 16/05/24.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable{
    case sheep
    case chiken
    case cow
    case human
    case tree
    case furniture
    case garden
    
    var label:String {
        get {
            switch self {
            case .sheep:
                return "Sheep"
            case .chiken:
                return "Chiken"
            case .cow:
                return "Cow"
            case .human:
                return "Human"
            case .tree:
                return "Tree"
            case .furniture:
                return "Furniture"
            case .garden:
                return "Garden"
            }
        }
    }
}

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named : name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    //method async model
    func asyncLoadModelEntity(){
        let filename = self.name + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion{
                case .failure(let error): print("unable load \(filename). error \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelentity for \(self.name) has been loaded")
            })
    }
    
    func asyncloadmodel(){
        let filename2 = self.name + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename2)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion{
                case .failure(let error): print("unable load \(filename2). error \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation

                print("modelentity for \(self.name) has been loaded")
            })
    }
}

struct Models {
    var all: [Model] = []
    
    init(){
        //cow
        let cow1 = Model(name: "Cow", category: .cow, scaleCompensation: 50/100)
        let cow2 = Model(name: "Cow2", category: .cow, scaleCompensation: 90/100)
        
        self.all += [cow1, cow2]
        
        //sheep
        let sheep1 = Model(name: "Sheep", category: .sheep, scaleCompensation: 70/100)
        let sheep2 = Model(name: "sheep2", category: .sheep, scaleCompensation: 20/100)
        
        self.all += [sheep1, sheep2]
        
        //chiken
        let chick1 = Model(name: "Chick", category: .chiken, scaleCompensation: 10/100)
        let chick2 = Model(name: "Chick2", category: .chiken, scaleCompensation: 80/100)
        
        self.all += [chick1, chick2]
        
        //human
        let human1 = Model(name: "ganyu", category: .human, scaleCompensation: 100/100)
        let human2 = Model(name: "anime_girl_but_idk", category: .human, scaleCompensation: 50/100)
        let human3 = Model(name: "elaina2", category: .human, scaleCompensation: 50/100)
        let human4 = Model(name: "FREE_Annie_anime_gerl", category: .human, scaleCompensation: 50/100)
        let human5 = Model(name: "human_girl", category: .human, scaleCompensation: 50/100)

        self.all += [human1, human2, human3, human4, human5]
        
        //tree
        let tree1 = Model(name: "Tree1", category: .tree, scaleCompensation: 50/100)
        
        self.all += [tree1]
        
        //furniture
        let furni1 = Model(name: "Fence_Wood", category: .furniture, scaleCompensation: 50/100)
        let furni2 = Model(name: "Farm_Pigsty", category: .furniture, scaleCompensation: 50/100)
        let furni3 = Model(name: "Fence_Wood", category: .furniture, scaleCompensation: 50/100)

        
        self.all += [furni1, furni2, furni3]
        
        //garden
        let garden1 = Model(name: "Field", category: .garden, scaleCompensation: 100/100)
        let garden2 = Model(name: "Grass", category: .garden, scaleCompensation: 50/100)

        self.all += [garden1, garden2]
    }
    
    func get(category: ModelCategory) -> [Model]?{
        return all.filter({$0.category == category})
    }
}
