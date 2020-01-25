//
//  MorsePlayerView.swift
//  Morse
//
//  Created by Jaime on 17/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit


public class MorsePlayerView: UIView {

    public var timeRatio = 0.20
    public var originDelayUnit = 4.0
    public var spaceRatio = 16.0
    public var endDelayUnit = 2.0

    
    
    public var letter: MorseLetter
    var playerButton = UIImageView()
    var pauseButton = UIImageView()
    
    var timers: [Timer] = []
    
    var toneAudioUnit = ToneAudioUnit.shared
    
    public var morseView: MorseLetterView!
    
    public var progressBar: UIView!
    
    
    var isPlaying = false
    
    public init(letter: MorseLetter) {
        self.letter = letter
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: spaceRatio * 3))
        backgroundColor = Colors.gray10
        layer.cornerRadius = 20
        
        progressBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: spaceRatio*3))
        progressBar.backgroundColor = Colors.gray25
        progressBar.layer.cornerRadius = 8
        addSubview(progressBar)
        
        playerButton.frame = CGRect(x: spaceRatio, y: 0, width: 24, height: 24)
        playerButton.center.y = frame.height/2
        addSubview(playerButton)
        playerButton.image = UIImage(named: "play")
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tappedPlayButton))
        tap.minimumPressDuration = 0
        playerButton.addGestureRecognizer(tap)
        playerButton.isUserInteractionEnabled = true
        
        morseView = MorseLetterView(letter, withSize: CGFloat(spaceRatio))
        morseView.frame.origin.x = CGFloat(originDelayUnit * spaceRatio)
        morseView.center.y = frame.height/2
        addSubview(morseView)
        
        let width = morseView.frame.maxX + CGFloat(spaceRatio * endDelayUnit)
        frame.size = CGSize(width: width, height: frame.height)
        
      
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedPlayButton(_ sender: UILongPressGestureRecognizer) {
        toneAudioUnit.enableSpeakerIfNedded()
        if !isPlaying {
            
            switch sender.state {
            case .began:
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.playerButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                    })
            default:
                playSound()
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.playerButton.transform = CGAffineTransform(rotationAngle: 20).scaledBy(x: 0.5, y: 0.5)
                    self.playerButton.alpha = 0
                })
            }
            
        }
    }
    
    
    
    func playSound(){
        isPlaying = true
        var delayUnit: Double = originDelayUnit
        
        for signalView in morseView.signalViews {
            let signal = signalView.type
            let timeUnit: Double = Double(signal.refSize)
            
            timers.append(Timer.scheduledTimer(timeInterval: delayUnit * timeRatio,
                                 target: self,
                                 selector: #selector(asyncPlaySound),
                                 userInfo: signalView,
                                 repeats: false))
            delayUnit = delayUnit + timeUnit + 1
        }
        
        UIView.animate(withDuration: (delayUnit + endDelayUnit - 1) * timeRatio, delay: 0, options: .curveLinear, animations: {
            self.progressBar.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        }, completion: { _ in
            self.playerButton.transform = CGAffineTransform(rotationAngle: -20)
                .scaledBy(x: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, animations: {
                self.progressBar.alpha = 0
                self.playerButton.transform = .identity
                self.playerButton.alpha = 1
                self.morseView.signalViews.forEach { view in
                    view.hideAnimatedColor()
                }
                
            }, completion: { _ in
                self.isPlaying  = false
                self.progressBar.alpha = 1
                self.progressBar.frame.size = CGSize(width: 0, height: self.frame.height)
            })
        })
    
       
    }
    
    @objc func asyncPlaySound(_ timer: Timer){
        guard let signalView = timer.userInfo as? MorseSignalView else {return}
        let time = timeRatio * Double(signalView.type.refSize)
//        self.toneAudioUnit.setToneTime(t: time)
        self.toneAudioUnit.play(tone: .A4, forDuration: time)
        signalView.animateColor(time: time, color: Colors.gray50)

    }

    

    func detach() {
        self.timers.forEach { timer in timer.invalidate() }
        self.toneAudioUnit.stop()
        if self.toneAudioUnit.isSpeakerEnabled {
            self.toneAudioUnit.removeSpeaker()
        }
    }
       
}


