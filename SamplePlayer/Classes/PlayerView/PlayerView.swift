//
//  PlayerView.swift
//  Pods-SamplePlayer_Example
//
import Foundation
import UIKit
import AVKit

public enum VideoStatus: Int {
    case Paused = 0
    case Waiting = 1
    case Play = 2
}

public class PlayerView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var currentDurationLabel: UILabel!
    
    //MARK: - Variables
    open var player: CustomPlayer?
    public var delegates: PlayerDelegates?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.player != nil {
            self.player?.updateLayerFrame(frame: videoView.bounds)
        }
    }
    
    public override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func playerSetUp(with frame: CGRect, and videoPath: String) {
        self.player = CustomPlayer(frame: frame, videoView: videoView, videoPath: videoPath)
        self.player?.delegates = self
        
        self.playerSlider.minimumValue = 0
        self.playerSlider.maximumValue = self.player?.duration ?? 1
        
        let watch = StopWatch(totalSeconds: Int(self.player?.duration ?? 0))
        if self.totalDurationLabel != nil {
            self.totalDurationLabel.text = watch.simpleTimeString
        }
        self.playerSlider.addTarget(self, action: #selector(playbackSlider(_:_:)), for: .valueChanged)
        
        self.player?.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        self.player?.player?.addObserver(self, forKeyPath: "timedMetadata", options: [], context: nil)
        
    }
    
    //
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if self.delegates != nil {
                self.delegates?.playStatus(status: VideoStatus(rawValue: newStatus?.rawValue ?? 0) ?? .Waiting)
            }
            if newStatus != oldStatus {
//                DispatchQueue.main.async {[weak self] in
//                    if newStatus == .playing || newStatus == .paused {
//                        print(newStatus?.rawValue)
////                        self?.loaderView.isHidden = true
//                    } else {
//                        print(newStatus?.rawValue)
////                        self?.loaderView.isHidden = false
//                    }
//                }
            }
        }else if keyPath == "timedMetadata" {
            let data: AVPlayerItem = object as! AVPlayerItem

            for item in data.timedMetadata! as [AVMetadataItem] {
                print("Meta Data: ",item.value as Any)
            }
        }
    }
    
    
    @IBAction func playbackSlider(_ sender: UISlider,_ event: UIEvent) {
        self.player?.playbackSliderValueChanged(sender, event)
        if self.delegates != nil {
            self.delegates?.playerProgress(sender.value)
        }
    }
    
    //Video Play Rate
    public func updatePlayRate(with rate: Float) -> Float {
        self.player?.rate = rate
        return self.player?.rate ?? 1.0
    }
    
    //Play & Pause Video Options
    
    @IBAction func playOptionsTapped(_ sender: UIButton) {
        if let status = self.player?.playingVideo() {
//            sender.setImage(playStatus ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
            if self.delegates != nil {
                self.delegates?.playStatus(status: status ? .Paused : .Play)
            }
        }
    }
    
    //Play
    public func playVideo() {
        if self.player != nil {
            self.player?.playVideo()
        }
    }
    
    //Pause
    public func pauseVideo() {
        if self.player != nil {
            self.player?.pauseVideo()
        }
    }
    
    @IBAction func rewindTapped(_ sender: UIButton) {
        self.player?.rewindVideo(10)
        if self.delegates != nil {
            self.delegates?.rewind()
        }
    }
    @IBAction func forwardTapped(_ sender: UIButton) {
        self.player?.forwardVideo(10)
        if self.delegates != nil {
            self.delegates?.forward()
        }
    }
    @IBAction func muteOptionsTapped(_ sender: UIButton) {
        if (self.player?.speakerOption()) != nil {
//            sender.setImage(muteStatus ? Images.Mute : Images.UnMute, for: .normal)
            if self.delegates != nil {
                
            }
        }
    }
    
    
    deinit {
        self.player = nil
        print("Player View Deinitialized")
    }
}



extension PlayerView: CustomPlayerDelegates {
    public func duationObserver(_ progress: Float) {
        self.playerSlider.value = progress
//        print("Current Time: ",StopWa)
        let watch = StopWatch(totalSeconds: Int(progress))
        if self.currentDurationLabel != nil {
            self.currentDurationLabel.text = watch.simpleTimeString
        }
        if self.delegates != nil {
            self.delegates?.playerProgress(progress)
        }
    }
    
    public func videoEnded() {
        if self.delegates != nil {
            self.delegates?.videoEnded()
        }
    }
}


extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
}

