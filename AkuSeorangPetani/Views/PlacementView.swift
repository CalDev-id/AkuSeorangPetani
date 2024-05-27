//
//  PlacementView.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 16/05/24.
//

import SwiftUI
struct PlacementView:View {
    @EnvironmentObject var placementSettings: PlacementSettings

    var body: some View {
        HStack{
            Spacer()
            PlacementButton(systemIconName: "xmark.circle.fill"){
                print("cancel placement pressed")
                self.placementSettings.selectedModel = nil
            }
            Spacer()
            PlacementButton(systemIconName: "checkmark.circle.fill"){
                print("confirm placement pressed")
                self.placementSettings.confirmedModel = self.placementSettings.selectedModel
                self.placementSettings.selectedModel = nil
            }
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

struct PlacementButton:View {
    let systemIconName: String
    let action: () -> Void
    var body: some View {
        Button(action: {self.action()}){
            Image(systemName: systemIconName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)
    }
}
