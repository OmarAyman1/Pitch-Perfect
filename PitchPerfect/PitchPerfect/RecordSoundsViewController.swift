//
//  RecordSoundsSViewController.swift
//  PitchPerfect
//
//  Created by OMAR on 3/30/19.
//  Copyright © 2019 OMAR. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    

    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    func enablingButtons(_ bool1: Bool ){
        if bool1 {
            RecordingLabel.text = "Recording in progress"
            RecordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        }
        else {
            RecordingLabel.text = "Tap to record"
            RecordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    
    @IBAction func RecordAudio(_ sender: Any) {
        let bool2 = true
        
        enablingButtons(bool2)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
   
    @IBAction func StopRecording(_ sender: Any) {
        let bool3 = false
        
        enablingButtons(bool3)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
