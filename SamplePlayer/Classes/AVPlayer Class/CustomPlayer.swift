//
//  CustomPlayer.swift
//  Pods-SamplePlayer_Example
//

import UIKit
import AVKit
import AVFoundation

@objc public protocol CustomPlayerDelegates {
    func duationObserver(_ progress: Float)
    func videoEnded()
}


public class CustomPlayer {

    //MARK: - IBOutlets
    private var videoView: UIView!
    
    
    //MARK: - Variables
    private var player:AVPlayer?
    private var playerItem:AVPlayerItem?
    private var urlPath: URL!
    private var isSlider: Bool = false
    open var videoPath: String!
    public var duration: Float!
    public var delegates: CustomPlayerDelegates!
    private var timeObserver: Any!
    
    public init(frame: CGRect, videoView: UIView, videoPath: String) {
        self.videoView = videoView
        self.videoPath = videoPath
        self.customPlayerSetup(frame: frame)
    }
    
    private func customPlayerSetup(frame: CGRect) {
        if let url = URL(string: videoPath ?? "") {
            urlPath = url
        }else {
            let url = URL(fileURLWithPath: videoPath ?? "")
            urlPath = url
        }
        let playerItem:AVPlayerItem = AVPlayerItem(url: urlPath)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame = frame
        print("Layer Frame: \(playerLayer.frame)")
        self.videoView.layer.addSublayer(playerLayer)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        self.duration = Float(seconds)
        
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main, using: {[unowned self] (progressTime) in
            if (self.player?.currentItem?.duration) != nil {
                let seconds = CMTimeGetSeconds(progressTime)
                if !self.isSlider {
                    DispatchQueue.main.async {
                        self.delegates.duationObserver(Float(seconds))
                    }
                }
            }
        }) ?? 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying(_:)), name: NSNotification.Name("AVPlayerItemDidPlayToEndTimeNotification"), object: nil)
    }
    
    //MARK: Play - Pause
    public func playingVideo() -> Bool {
        if self.player?.isPlaying ?? false {
            self.pauseVideo()
        }else {
            self.playVideo()
        }
        return self.player?.isPlaying ?? false
    }
    
    //MARK: Play
    private func playVideo() {
        self.player?.play()
    }
    
    //MARK: Pause
    private func pauseVideo() {
        self.player?.pause()
    }
    
    //MARK: Speaker
    public func speakerOption() -> Bool {
        if self.player?.isMuted ?? false {
            self.unmuteVideo()
        }else {
            self.muteVideo()
        }
        return self.player?.isMuted ?? false
    }
    
    //MARK: Mute
    private func muteVideo() {
        self.player?.isMuted = true
    }
    
    //MARK: UnMute
    private func unmuteVideo() {
        self.player?.isMuted = false
    }
    
    //MARK: Rewind Video
    public func rewindVideo(_ seconds: Float64) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    //MARK: Forward Video
    public func forwardVideo(_ seconds: Float64) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    //Progress Slider User Interacted
    public  func playbackSliderValueChanged(_ playbackSlider:UISlider,_ event: UIEvent)
       {
           let seconds : Int64 = Int64(playbackSlider.value)
           let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)

           
           player!.seek(to: targetTime)
           if let touchEvent = event.allTouches?.first {
               switch touchEvent.phase {
               case .began:
                   isSlider = true
               case .ended:
                   isSlider = false
               default:
                   break
               }
           }
        if player!.rate == 0 && ((player?.isPlaying) == true)
           {
               player?.play()
           }

       }
    
    //MARK: Video Ended
    @objc func playerEndedPlaying(_ notification: NSNotification) {
        DispatchQueue.main.async {[unowned self] in
            self.player?.seek(to: CMTime.zero)
            self.delegates.videoEnded()
        }
    }
    
    deinit {
        self.player?.removeTimeObserver(self.timeObserver!)
        self.player = nil
        self.playerItem = nil
        NotificationCenter.default.removeObserver(self)
        print("Custom Player Deinitialized....")
    }
}