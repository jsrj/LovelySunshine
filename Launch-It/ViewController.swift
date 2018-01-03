//
//  ViewController.swift
//  Launch-It
//
//  Created by Arjay Jones on 1/2/18.
//  Copyright © 2018 ArjayCodes. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var powerButton:    UIButton!
    @IBOutlet weak var skyBG:          UIImageView!
    @IBOutlet weak var sunshineLabel:  UILabel!
    @IBOutlet weak var animationScene: UIView!
    @IBOutlet weak var sunGuy:         UIImageView!
    @IBOutlet weak var sunRays:        UIImageView!
    @IBOutlet weak var helloWorld:     UIImageView!
    @IBOutlet weak var clouds:         UIImageView!
    @IBOutlet weak var landscape:      UIImageView!
    @IBOutlet weak var fin:            UIView!
    
    var bgmJukeBox: AVAudioPlayer!
    var sfxJukeBox: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        animationScene.isHidden = true
        skyBG.isHidden          = false
        powerButton.isHidden    = false
        
        let bgMusicPath = Bundle.main.path(
            forResource: "Classical-Music-Morning-Song",
            ofType: "wav"
            )!
        let bgmURL = URL(fileURLWithPath: bgMusicPath)
        
        let sunScreamPath = Bundle.main.path(
            forResource: "ScreamingSun",
            ofType: "m4a")!
        let sunScreamURL = URL(fileURLWithPath: sunScreamPath)
        
        do
        {
            bgmJukeBox = try AVAudioPlayer(contentsOf: bgmURL)
            sfxJukeBox = try AVAudioPlayer(contentsOf: sunScreamURL)
            bgmJukeBox.prepareToPlay()
            sfxJukeBox.prepareToPlay()
        }
        catch let error as NSError
        {
            print(error.description)
        }
    }
    @IBAction func bringMeTheSun(_ sender: UIButton!) {
        let sequence1Time  = 6.0
        let sequence2Time  = 2.0
        let sequence2Delay = 2.0
        let sequence3Time  = sequence1Time
        
        self.sunRays.alpha    = 0
        self.helloWorld.alpha = 0
        
        animationScene.isHidden = false
        skyBG.isHidden          = true
        powerButton.isHidden    = true
        
        // Starts playing a lovely tune once user calls for sunshine
        bgmJukeBox.play()
        
        // Starts the lovely vocal track provided by sun guy
        self.sfxJukeBox.numberOfLoops = 10
        self.sfxJukeBox.setVolume(0.00, fadeDuration: 0.00)
        self.sfxJukeBox.play()
        
        self.bgmJukeBox.setVolume(0.60, fadeDuration: 3.00)

        UIView.animate(
            withDuration: sequence1Time+sequence2Time,
            animations: {
                // Adjust volume of scream *ahem* the beautiful vocals to coincide with the sun guy's rising.
                self.sfxJukeBox.setVolume(2.50, fadeDuration: 6.00)
                
                // Animates sun guy rising over horizon.
                self.sunGuy.frame = CGRect(
                    x:      117,
                    y:      222,
                    width:  140,
                    height: 140
                )
        }) { (seq1Finished) in
            UIView.animate(
                withDuration: sequence2Time,
                animations:
                {
                    // Sunrise...
                    // Animates sun rays becoming visible after sun guy rises.
                    self.sunRays.isHidden = false
                    self.sunRays.alpha    = 1
                        
                    // Animates hello world becoming visible with sun rays
                    self.helloWorld.isHidden = false
                    self.helloWorld.alpha = 1
                },
                completion: { (seq2finished) in
                    // Third sequence that reverses process of first sequence.
                    UIView.animate(
                        withDuration: sequence2Time,
                        delay: sequence2Delay,
                        animations: {
                        // Animates sun rays fading before sun guy sets.
                        self.sunRays.alpha    = 0
                        
                        // Animates hello world fading before sun guy sets.
                        self.helloWorld.alpha = 0
                    }, completion:
                        {
                            (fadeOutFinished) in
                            self.sfxJukeBox.setVolume(0.0, fadeDuration: 8.00*sequence2Delay)
                            UIView.animate(
                                withDuration: 10.00,
                                delay: sequence2Delay,
                                animations: {
                                    self.sunGuy.frame = CGRect(
                                        x: 117,
                                        y: 522,
                                        width: 140,
                                        height: 140
                                        )
                                },
                                completion: { (seq3finished) in
                                    self.sfxJukeBox.stop()
                                    self.bgmJukeBox.setVolume(0.0, fadeDuration: 4.00)
                                    UIView.animate(
                                        withDuration: 2.00, delay: 4.00, animations: {
                                            self.fin.alpha = 1
                                    })
                    })
                })
            })
        }
    }
}

