//
//  VideoView.swift
//  AkuSeorangPetani
//
//  Created by Heical Chandra on 21/05/24.
//

import SwiftUI
import AVKit

struct VideoManager: UIViewRepresentable {
    var videoName: String
    
    init(videoName: String){
        self.videoName = videoName
    }
  
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoManager>) {
    }
  
    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(videoName: videoName)
    }
}

class LoopingPlayerUIView: UIView {
  
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var player = AVQueuePlayer()
  
    init(videoName: String){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: videoName, ofType: "mp4")!)
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)

        super.init(frame: .zero)
        
        // Setup the player
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        player.play()
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
