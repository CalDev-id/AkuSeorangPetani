//
//  Audio.swift
//  AkuSeorangPetani
//
//  Created by Heical Chandra on 25/05/24.
//

import AVFoundation


var player: AVAudioPlayer!


func playSound(name: String, extensionFile: String) {
    let url = Bundle.main.url(forResource: name, withExtension: extensionFile)

    // Do nothing if this url is empty
    guard url != nil else {
        return
    }

    do {
        player = try AVAudioPlayer(contentsOf: url!)
        player?.numberOfLoops = -1 // Loop indefinitely
        player?.play()
    } catch {
        print("\(error)")
    }
}

func stopSound() {
    player?.stop()
}
