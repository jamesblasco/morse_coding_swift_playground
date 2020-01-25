//
//  AnimatedMorseGameView.swift
//  Book_Sources
//
//  Created by Jaime on 22/03/2019.
//

import UIKit


public class MorseGameView: UIView {
    public var game: Game!
   
    public var lines: [Int:UIView] = [:]
    public var morseletterViews: [Int: MorseSignalView] = [:]
    public var letterViews: [Int: LetterView] = [:]
    
    public var letters: [MorseLetter]
    
    public init(game: Game, letters: [MorseLetter]) {
        self.letters = letters
        self.game = game
        super.init(frame: .zero)
        game.letters = letters
        
        frame.size = CGSize(width: game.getPosition(for: game.referencesCount),
                            height: game.height)
        addLines()
        addSignalViews()
        
        
        //        addLetters(letters)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addSignalViews() {
        var ref = game.startReference
        letters.forEach { letter in
            lines[ref]?.frame.size.width = 2
            let letterView = LetterView(letter, withHeight: Size.medium.letterHeight)
            letterViews[ref] = letterView
            letterView.setGreyMode()
            addSubview(letterView)
            letterView.frame.origin = CGPoint(x: game.getPosition(for: ref), y: 0)
            letterView.center.y = self.center.y - game.getPosition(for: 1)
            
            letter.code.forEach{ signal in
                let signalView = MorseSignalView(type: signal,
                                                 color: letter.color,
                                                 withSize: game.getPosition(for: 1))
                morseletterViews[ref] = signalView
                addSubview(signalView)
                signalView.frame.origin = CGPoint(x: game.getPosition(for: ref), y: 0)
                signalView.center.y = self.center.y + game.getPosition(for: 1)
                ref += signal.refSize + 1
            }
            ref += 2
        }
    }
    
    //AddLines
    public func addLines() {
        for ref in 0...game.referencesCount{
            let line = UIView()
            line.backgroundColor = Colors.gray25
            line.frame.size = CGSize(width: 1, height: game.height)
            line.frame.origin = CGPoint(x: game.getPosition(for: ref), y: 0)
            addSubview(line)
            lines[ref] = line
        }
    }
    
    
}

