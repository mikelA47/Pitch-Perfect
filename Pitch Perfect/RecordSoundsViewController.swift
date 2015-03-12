//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mikel Lizarralde Cabrejas on 4/3/15.
//  Copyright (c) 2015 TheUnit. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var pauseRecorder = false
    //var created to be able to discriminate if we paused the recording at least once, if we pause at least once the recording it will show a message and whenever we tap again the microphone it will resume the recording using the same file instead of a new one
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        recordingLabel.hidden = false //Task 4, now the message should appear from the first moment instead of being hidden as the lesson requested
        recordingLabel.text = "Tap to Record" //Task 4
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func microphonePressed(sender: UIButton) {
        recordingLabel.text = "Recording in process"
        stopButton.hidden = false
        pauseButton.hidden = false
        recordButton.enabled = false
        
        if (pauseRecorder == false) { //false if is a new recording true if we resume the recording
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
        
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        else {
            audioRecorder.record()
            recordingLabel.text = "Recording in process"
        }
    }
    
    @IBAction func pausePressed(sender: UIButton) {
            audioRecorder.pause()
            pauseRecorder = true //We change the value to true to indicate that the record has been paused. Because of that when we press the microphen again no new file will be created
            recordingLabel.text = "Tap to continue recording"
            pauseButton.hidden = true
            recordButton.enabled = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathURL: recorder.url,title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    @IBAction func stopPressed(sender: UIButton) {
        recordingLabel.hidden = true
        pauseButton.hidden = true
        audioRecorder.stop()
        pauseRecorder = false
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

