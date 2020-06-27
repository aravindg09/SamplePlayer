//
//  AVPlayerExtension.swift
//  Pods-SamplePlayer_Example
//

import Foundation
import AVKit


extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
