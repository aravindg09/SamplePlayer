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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlPath = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        customPlayerView.playerSetUp(with: customPlayerView.bounds, and: urlPath)
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
