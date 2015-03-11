//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mikel Lizarralde Cabrejas on 7/3/15.
//  Copyright (c) 2015 TheUnit. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBAction func playReverb(sender: UIButton) {
        playAudioWithReverb()
        
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func chipmunkPressed(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func stopPressed(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    @IBAction func fastPressed(sender: UIButton) {
        audioPlayer.rate = 2
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    @IBAction func slowPressed(sender: UIButton) {
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playAudioEcho(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
       
        var reverbNode: AVAudioUnitReverb = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.Cathedral)
        reverbNode.wetDryMix = 50
        var delayNode: AVAudioUnitDelay = AVAudioUnitDelay()
        delayNode.wetDryMix = 30
        audioEngine.attachNode(delayNode)
        audioEngine.attachNode(reverbNode) //add reverb node for a more credible effect
        
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        
        audioEngine.connect(reverbNode, to: delayNode, format: nil)
        audioEngine.connect(delayNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    func playAudioWithReverb(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var reverbNode: AVAudioUnitReverb = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.LargeHall)
        reverbNode.wetDryMix = 50
        
        audioEngine.attachNode(reverbNode)
        
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*      if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
            var filePathUrl = NSURL.fileURLWithPath(filePath)
            //audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
            //audioPlayer.enableRate = true
        }else{
            println("Error. The filePath is empty\n")
        }*/

        // Do any additional setup after loading the view.
      
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
