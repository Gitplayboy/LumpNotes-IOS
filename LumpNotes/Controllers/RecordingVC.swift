//
//  RecordingVC.swift
//  LumpNotes
//
//  Created by vibin joby on 2020-01-25.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingVC: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingImgView: UIImageView!
    @IBOutlet weak var recorderTimerLbl: UILabel!
    var parentController:AddEditNoteVC?
    var audioRecorder: AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onRecordingCancel(_ sender: UIButton) {
        if let parentVC = parentController {
            parentVC.cancelRecording()
            parentVC.audioView.isHidden = true
        }
    }
    
    @IBAction func onRecordingSave(_ sender: UIButton) {
        if let parentVC = parentController {
            parentVC.stopRecording()
            parentVC.audioView.isHidden = true
        }
    }
}
