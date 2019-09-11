//
//  ViewController.swift
//  StackOverflowExample
//
//  Created by Dave Troupe on 9/11/19.
//  Copyright © 2019 High Tree Development. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    var lockScreenPlayingInfo: [String: Any]?
    let lockScreenInfo = LockScreenInfo()

    var bgTimer: Timer?
    var mainThreadTimer: Timer?

    let q = DispatchQueue(label: "serialQueue")
    var serialTimer: Timer?

    var accessSafely: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        bgTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] timer in
            guard let sself = self else { return }

            DispatchQueue.global(qos: .background).async {
                print("Adding values to dictionary")

                if sself.accessSafely {
                    var dict = [String: Any]()
                    dict[MPMediaItemPropertyTitle] = "Track title"
                    dict[MPMediaItemPropertyAlbumTitle] = "Album Title"
                    dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 10
                    dict[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
                    self?.lockScreenInfo.setValues(dict)
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.lockScreenInfo.getValues()
                } else {
                    self?.lockScreenPlayingInfo = [String: Any]()
                    self?.lockScreenPlayingInfo?[MPMediaItemPropertyTitle] = "Track title"
                    self?.lockScreenPlayingInfo?[MPMediaItemPropertyAlbumTitle] = "Album Title"
                    self?.lockScreenPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 10
                    self?.lockScreenPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.lockScreenPlayingInfo
                }
            }
        })

        mainThreadTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] timer in
            guard let sself = self else { return }
            let random = Double.random(in: 0.001..<0.8)

            DispatchQueue.main.asyncAfter(deadline: .now() + random, execute: {
                print("modifying dictionary")

                if sself.accessSafely {
                    var dict = [String: Any]()
                    dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 2
                    dict[MPNowPlayingInfoPropertyPlaybackRate] = 0
                    self?.lockScreenInfo.updateValues(dict)
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.lockScreenInfo.getValues()
                } else {
                    self?.lockScreenPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 2
                    self?.lockScreenPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.lockScreenPlayingInfo

                }
            })
        })

        serialTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [weak self] timer in
            guard let sself = self else { return }

            sself.q.sync {
                print("clearing dictionary")

                if sself.accessSafely {
                    sself.lockScreenInfo.clearAllValues()
                } else {
                    sself.lockScreenPlayingInfo = [:]
                }
            }
        })
    }
}
