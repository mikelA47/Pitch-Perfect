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
    /*
    Udacity assessment: "The stopPressed function is defined in the PlaySoundsViewController but not used at all.."
    This function is an Interface Builder Action that occurs when the stop button is pressed. It´s in use and in my opinion is necesary to give the chance to the users to stop listening what they recorded, but if you think is no necesary I can take it out and break the connection with the button.
    */
    @IBAction func stopPressed(sender: UIButton) {
        stopEngineAudioPlayer()
    }
    @IBAction func fastPressed(sender: UIButton) {
        playAudioWithVariableRate(2) //put code into a function because almost the same than slow
    }
    @IBAction func slowPressed(sender: UIButton) {
        playAudioWithVariableRate(0.5) //put code into a function because almost the same than fast
    }
    
    @IBAction func playAudioEcho(sender: UIButton) {
        stopEngineAudioPlayer() //task 3
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
       
        var reverbNode: AVAudioUnitReverb = AVAudioUnitReverb()//reverb node
        reverbNode.loadFactoryPreset(.Cathedral) //selction of the reverb effect from 1 to 12
        reverbNode.wetDryMix = 50 //kind of % of effect aply
        var delayNode: AVAudioUnitDelay = AVAudioUnitDelay() //delay node
        delayNode.wetDryMix = 30 //kind of % of effect apply
        audioEngine.attachNode(delayNode) //add delay node
        audioEngine.attachNode(reverbNode) //add reverb node for a more credible effect
        
        //conection of the nodes
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: delayNode, format: nil)
        audioEngine.connect(delayNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    func playAudioWithReverb(){
        stopEngineAudioPlayer() //task 3
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var reverbNode: AVAudioUnitReverb = AVAudioUnitReverb() //reverb effect node
        reverbNode.loadFactoryPreset(.LargeHall) //selection of the reverb effect from 1 to 12
        reverbNode.wetDryMix = 50 //% effect apply
        
        audioEngine.attachNode(reverbNode) //add reverb node
        
        //conection of the nodes
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    func playAudioWithVariableRate(rate: Float){
        stopEngineAudioPlayer() //task 3
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopEngineAudioPlayer() //task 3
        
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
    
    func stopEngineAudioPlayer() {  //function created to avoid repetition of code
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
