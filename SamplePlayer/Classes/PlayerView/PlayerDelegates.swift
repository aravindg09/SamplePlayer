//
//  PlayerDelegates.swift
//  SamplePlayer
//

import Foundation


public protocol PlayerDelegates {
    func playStatus(status: VideoStatus)
    func forward()
    func rewind()
    func playerProgress(_ progress: Float)
    func videoEnded()
}
