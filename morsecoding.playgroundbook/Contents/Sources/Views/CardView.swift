//
//  CardView.swift
//  Morse
//
//  Created by Jaime on 16/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit

public class CardView: UIView {
    
    public let shadow = UIView()
    public let card = UIView()
    public let topLine = UIView()
    
    public var letter: MorseLetter

    required init(letter: MorseLetter, frame: CGRect = .zero) {
        self.letter = letter
        super.init(frame: frame)
       
        addShadow()
        addCard()
        addTopLine()
        addLetter()
        addVisualRemainder()
        addSoundVisualRemainder()
        
        updateFrame()
    }
    
    public func updateFrame() {
       
        card.frame = CGRect(origin: .zero, size: bounds.size)
        
        topLine.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 48)
        shadow.frame = CGRect(origin: .zero, size: bounds.size)
        shadow.layer.shadowPath =
            UIBezierPath(roundedRect: shadow.bounds,
                         cornerRadius: 23).cgPath
        
        let scale = frame.width / Utils.minScreen.width
        letterView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        
//
        //Vertical aligment
        if frame.height > frame.width {
            letterView.frame.origin = CGPoint(x: frame.width/8, y: frame.height/5)
            
            let remainderScale = min(scale*2, 1)
            visualRemainderView.transform = CGAffineTransform(scaleX: remainderScale, y: remainderScale)
            soundLabel.transform = CGAffineTransform(scaleX: remainderScale, y: remainderScale)
            visualRemainderView.frame.origin = CGPoint(x: frame.width/8, y: frame.height/2)
            soundRemainderView.frame.origin = CGPoint(x: frame.width/8,
                                                      y: frame.height - frame.width/8 - soundRemainderView.frame.height)
            
           
//            visualRemainderView.transform = CGAffineTransform(scaleX: scale, y: scale)
        } else {
            letterView.frame.origin = CGPoint(x: frame.width/12, y: frame.height/5)
            visualRemainderView.frame.origin = CGPoint(x: frame.width/12, y: 2*frame.height/3)
            
            soundRemainderView.frame.origin = CGPoint(x: 7*frame.width/12, y: 2*frame.height/3)
           
            
            let remainderScale = min(scale*1.2, 1)
            visualRemainderView.transform = CGAffineTransform(scaleX: remainderScale, y: remainderScale)
            soundLabel.transform = CGAffineTransform(scaleX: remainderScale, y: remainderScale)
        }
        
      
        
    }

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShadow() {
        self.addSubview(shadow)
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 12)
        shadow.layer.shadowRadius = 36
        shadow.layer.shadowOpacity = 0.2
        shadow.clipsToBounds = false
       
      
       
    }
   
    
    func addCard() {
        self.addSubview(card)
        card.backgroundColor = .white
        card.layer.cornerRadius = 23
        
        
    }
    
   
    func addTopLine() {
        self.addSubview(topLine)
        topLine.backgroundColor = letter.color
        topLine.layer.cornerRadius = 23
        if #available(iOS 11.0, *) {
            topLine.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    var letterView: UIView!
   
    
    func addLetter() {
        
        var charView: LetterView!
        var morseView: MorseLetterView!
        charView = letter.createLetterView(withHeight: Size.big.letterHeight)
        morseView = letter.createMorseView(withSize: Size.big.signalSize)
        morseView.frame.origin = CGPoint(x: charView.frame.maxX + Size.big.letterHeight/3, y: charView.frame.maxY - morseView.frame.height)
        
        
        letterView = UIView(frame: CGRect(x: 0, y: 0,
                                          width: morseView.frame.maxX,
                                          height: morseView.frame.maxY))
        letterView.addSubview(charView)
        letterView.addSubview(morseView)
        addSubview(letterView)
       
    }
    
   
    
    var visualRemainderView: UIView!
    func addVisualRemainder() {
        visualRemainderView = UIView()
        
        let visualLabel = UILabel()
        visualLabel.text = "VISUAL REMAINDER"
        visualLabel.font = UIFont.boldSystemFont(ofSize: 19)
        visualLabel.textColor = Colors.gray85
        visualLabel.sizeToFit()
        visualRemainderView?.addSubview(visualLabel)
        
        let letterMorseView = letter.createLetterView(withHeight: Size.medium.letterHeight)
        letterMorseView.frame.origin = CGPoint(x: 0, y: visualLabel.frame.maxY + 24)
        letterMorseView.setMorseMode()
        visualRemainderView?.addSubview(letterMorseView)
        
        addSubview(visualRemainderView)
        visualRemainderView.frame.size = CGSize(width: visualLabel.frame.width, height: letterMorseView.frame.maxY)
        
        
    
    }
    
    let soundLabel = UILabel()
    var soundRemainderView: UIView!
    var morsePlayerView: MorsePlayerView!
    func addSoundVisualRemainder() {
        soundRemainderView = UIView()
        
        
        soundLabel.text = "SOUND REMAINDER"
        soundLabel.font = UIFont.boldSystemFont(ofSize: 19)
        soundLabel.textColor = Colors.gray85
        soundLabel.sizeToFit()
        soundRemainderView?.addSubview(soundLabel)
        
        morsePlayerView = MorsePlayerView(letter: letter)
        morsePlayerView.frame.origin = CGPoint(x: 0, y: soundLabel.frame.maxY + 24)
        soundRemainderView?.addSubview(morsePlayerView)
        
        addSubview(soundRemainderView)
        soundRemainderView.frame.size = CGSize(width: soundLabel.frame.width,
                                               height: morsePlayerView.frame.maxY)
    
      
        
    }
    
  
}
