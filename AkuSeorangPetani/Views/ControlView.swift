//
//  ControlView.swift
//  AkuSeorangPeternak
//
//  Created by Heical Chandra on 15/05/24.
//

import SwiftUI

struct ControlView: View {
    @Binding var isControlsVisible:Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings:Bool
    var body: some View {
        VStack{
//            ControlVisibilityToggleButton(isControlsVisible: $isControlsVisible)
            Spacer()
            if isControlsVisible{
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
            }
        }
    }
}

//struct ControlVisibilityToggleButton: View {
//    @Binding var isControlsVisible:Bool
//    var body: some View {
//        HStack{
//            Spacer()
//            ZStack{
//                Color.black.opacity(0.25)
//                Button(action: {
//                    print("pressed")
//                    self.isControlsVisible.toggle()
//                }){
//                    Image(systemName: self.isControlsVisible ? "rectangle" : "slider.horizontal.below.rectangle")
//                        .font(.system(size: 25))
//                        .foregroundColor(.white)
//                        .buttonStyle(PlainButtonStyle())
//                }
//            }
//            .frame(width: 50, height: 50)
//            .cornerRadius(8.0)
//        }
//        .padding(.top, 45)
//        .padding(.trailing, 20)
//    }
//}
struct ControlButtonBar: View {
    @Binding var showBrowse: Bool
    @Binding var showSettings:Bool
    var body: some View {
        HStack{
//            ControlButton(systemIconName: "clock.fill"){
////                print("recent")
//            }
            Spacer()
            ControlButton(systemIconName: "cart"){
//                print("browse")
                self.showBrowse.toggle()
            }.sheet(isPresented: $showBrowse, content: {
                //browse
                BrowseView(showBrowse: $showBrowse)
            })
            Spacer()
//            ControlButton2(systemIconName: "slider.horizontal.3"){
////                print("setting")
//                self.showSettings.toggle()
//            }.sheet(isPresented: $showSettings){
//                SettingsView(showSettings: $showSettings)
//            }
        }
        .frame(maxWidth: 500)
        .padding(30)
//        .background(Color.black.opacity(0.25))
    }
}

struct ControlButton: View {
    let systemIconName: String
    let action: () -> Void
    var body: some View {
        Button(action: {
            self.action()
        }){
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.black)
                .buttonStyle(PlainButtonStyle())
                
        }
        .frame(width: 50, height: 50)
        .padding()
        .background(.white)
        .cornerRadius(100)
    }
}

struct ControlButton2: View {
    let systemIconName: String
    let action: () -> Void
    var body: some View {
        Button(action: {
            self.action()
        }){
            Image(systemName: systemIconName)
                .font(.system(size: 30))
                .foregroundColor(.black)
                .buttonStyle(PlainButtonStyle())
                
        }
        .frame(width: 30, height: 30)
        .padding()
        .background(.white)
        .cornerRadius(100)
    }
}
