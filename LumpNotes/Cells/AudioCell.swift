//
//  ImageCell.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import AVFoundation

class AudioCell: UITableViewCell,AVAudioPlayerDelegate {

    //Audio
    var audioPlayer: AVAudioPlayer!
    var audioUrl:URL?
    var timer:Timer?
    @IBOutlet weak var audioProgress: UIProgressView!
    @IBOutlet weak var audioTime: UILabel!
    @IBOutlet weak var audioTimeLbl: UILabel!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBAction func onPlayBtnClick(_ sender: UIButton) {
        guard let url = audioUrl else { return }
        if playBtn.backgroundImage(for: .normal) != UIImage(systemName: "pause") {
            timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(trackAudio), userInfo: nil, repeats: true)
            //start Audio Playing
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
                audioPlayer.delegate = self
                playBtn.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
            } catch {
                print("error while recording")
            }
        } else {
            timer?.invalidate()
            audioPlayer.pause()
            playBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    @IBAction func onStopBtnClick(_ sender: Any) {
        audioPlayer.stop()
        playBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        audioProgress.setProgress(0,animated: true)
        timer?.invalidate()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        audioProgress.setProgress(0,animated: true)
        timer?.invalidate()
    }

    @objc func trackAudio() {
        let normalizedTime = Float(audioPlayer.currentTime * 100.0 / audioPlayer.duration)
        if normalizedTime > 100 {
            audioTimeLbl.text = "1:\(String(Int(audioPlayer.currentTime)))"
        } else {
            audioTimeLbl.text = "0:\(String(Int(audioPlayer.currentTime)))"
        }
        print(normalizedTime)
        audioProgress.setProgress(normalizedTime, animated: true)
    }
    
}
