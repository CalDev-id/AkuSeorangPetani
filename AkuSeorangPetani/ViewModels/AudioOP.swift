//
//  AudioOP.swift
//  AkuSeorangPetani
//
//  Created by Heical Chandra on 27/05/24.
//

import AVFoundation


var player2: AVAudioPlayer!

func playOP(name: String, extensionFile: String) {
    let url = Bundle.main.url(forResource: name, withExtension: extensionFile)

    // do nothing if this url is empty
    guard url != nil else {
        return
    }

    do {
        player2 = try AVAudioPlayer(contentsOf: url!)
        player2?.play()
    } catch {
        print("(error)")
    }
}

func stopOP() {
    player2?.stop()
}
