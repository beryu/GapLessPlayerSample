//
//  ViewController.swift
//  GapLessPlayer
//
//  Created by Ryuta Kibe on 2016/02/15.
//  Copyright © 2016年 blk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        let url1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("1", ofType: "m4a")!)
        let url2 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("2", ofType: "m4a")!)
        let asset1 = AVURLAsset(URL: url1)
        let asset2 = AVURLAsset(URL: url2)
        asset1.loadValuesAsynchronouslyForKeys(["duration", "playable", "tracks"], completionHandler: { () -> Void in
            asset2.loadValuesAsynchronouslyForKeys(["duration", "playable", "tracks"], completionHandler:  { () -> Void in
                NSLog("asset1.tracks: %@", asset1.tracks)
                let composition = AVMutableComposition()
                let audioTrack1 = asset1.tracksWithMediaType(AVMediaTypeAudio)[0]
                let audioTrack2 = asset2.tracksWithMediaType(AVMediaTypeAudio)[0]
                do {
                    try composition.insertTimeRange(audioTrack1.timeRange, ofAsset: asset1, atTime: kCMTimeZero)
                    try composition.insertTimeRange(audioTrack2.timeRange, ofAsset: asset2, atTime: audioTrack1.timeRange.duration)
                } catch (_) {
                }
                let playerItem = AVPlayerItem(asset: composition)
                self.player = AVPlayer(playerItem: playerItem)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playWasTapped(sender: AnyObject) {
        self.player.seekToTime(kCMTimeZero)
        self.player.play()
    }
}

