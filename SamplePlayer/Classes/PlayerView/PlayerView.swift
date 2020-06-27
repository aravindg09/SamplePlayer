//
//  PlayerView.swift
//  Pods-SamplePlayer_Example
//
import Foundation
import UIKit


public class PlayerView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playerSlider: UISlider!
    
    //MARK: - Variables
    open var player: CustomPlayer?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func playerSetUp(with frame: CGRect, and videoPath: String) {
        self.player = CustomPlayer(frame: frame, videoView: videoView, videoPath: videoPath)
        self.player?.delegates = self
        
        self.playerSlider.minimumValue = 0
        self.playerSlider.maximumValue = self.player?.duration ?? 1
        
        self.playerSlider.addTarget(self, action: #selector(playbackSlider(_:_:)), for: .valueChanged)
        
    }
    
    @IBAction func playbackSlider(_ sender: UISlider,_ event: UIEvent) {
        self.player?.playbackSliderValueChanged(sender, event)
    }
    
    @IBAction func playOptionsTapped(_ sender: UIButton) {
        if let playStatus = self.player?.playingVideo() {
//            sender.setImage(playStatus ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @IBAction func rewindTapped(_ sender: UIButton) {
        self.player?.rewindVideo(10)
    }
    @IBAction func forwardTapped(_ sender: UIButton) {
        self.player?.forwardVideo(10)
    }
    @IBAction func muteOptionsTapped(_ sender: UIButton) {
        if let muteStatus = self.player?.speakerOption() {
//            sender.setImage(muteStatus ? Images.Mute : Images.UnMute, for: .normal)
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
    }
    
    public func videoEnded() {
        
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

