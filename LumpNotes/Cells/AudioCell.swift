//
//  ImageCell.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioCellDelegate:class {
    func deleteAudio(cell: AudioCell)
}

class AudioCell: UITableViewCell,AVAudioPlayerDelegate {
    
    var delegate:AudioCellDelegate?
    //Audio
    var audioPlayer: AVAudioPlayer?
    var audioUrl:URL?
    var timer:Timer?
    @IBOutlet weak var audioProgress: UIProgressView!
    @IBOutlet weak var audioTimeLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBAction func onPlayBtnClick(_ sender: UIButton) {
        if audioUrl != nil {
            if playBtn.backgroundImage(for: .normal) != UIImage(systemName: "pause") {
                timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(trackAudio), userInfo: nil, repeats: true)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioUrl!)
                    audioPlayer!.play()
                    audioPlayer!.delegate = self
                    playBtn.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
                } catch let err as NSError {
                    print("error while recording \(err.localizedDescription) \(err.userInfo)")
                }
            } else {
                timer?.invalidate()
                audioPlayer!.pause()
                playBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
    @IBAction func onStopBtnClick(_ sender: Any) {
        if let player = audioPlayer {
            player.stop()
            playBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            audioProgress.setProgress(0,animated: true)
            timer?.invalidate()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        audioProgress.setProgress(0,animated: true)
        timer?.invalidate()
    }

    @objc func trackAudio() {
        if let audio = audioPlayer {
            let normalizedTime = Float(audio.currentTime * 100.0 / audio.duration)
            if normalizedTime > 100 {
                audioTimeLbl.text = "1:\(String(Int(audio.currentTime)))"
            } else {
                audioTimeLbl.text = "0:\(String(Int(audio.currentTime)))"
            }
            audioProgress.setProgress(normalizedTime, animated: true)
        } else {
            timer?.invalidate()
        }
    }
    @IBAction func onDelete(_ sender: UIButton) {
        delegate?.deleteAudio(cell: self)
    }
    
}
