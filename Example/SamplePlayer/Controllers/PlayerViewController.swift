//
//  PlayerViewController.swift
//  SamplePlayer_Example
//
//  Created by Aravind on 27/06/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SamplePlayer

class PlayerViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var customPlayerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                let urlPath = "https://djnr788nhodr8.cloudfront.net/SCTE%2035%20data/hallmarkmovies_IP_feed/package_4/hallmarkmovies_IP_feed_20200619-16.29.24.m3u8"
//                let urlPath = Bundle.main.path(forResource: "Sea - 33194", ofType: "mp4")!
                customPlayerView.playerSetUp(with: customPlayerView.bounds, and: urlPath)
        customPlayerView.playVideo()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.customPlayerView.delegates = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.customPlayerView.delegates = nil
    }
    
    deinit {
        self.customPlayerView.player = nil
        print("Player Controller Deinitialized")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayerViewController: PlayerDelegates {
    func playStatus(status: VideoStatus) {
        print(status.rawValue)
    }
    
    func forward() {
        print("Forward")
    }
    
    func rewind() {
        print("Rewind")
    }
    
    func playerProgress(_ progress: Float) {
        print(progress)
        
    }
    
    func videoEnded() {
        print("Ended")
    }
    
    
}
