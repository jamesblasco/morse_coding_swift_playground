//
//  GameView.swift
//  Morse
//
//  Created by Jaime on 17/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit

public class GameView: UIView {
    
    public var game = Game()
    
    private var finishLine = UIView()
    public var morseGameView: MorseGameView?
    
    public var finishedLetters: [LetterView] = []

    public var letters: [MorseLetter]? {
        didSet {
            guard let letters = letters else { return }
            game = Game()
            game.delegate = self
            morseGameView?.removeFromSuperview()
            morseGameView = MorseGameView(game: game, letters: letters)
            addSubview(morseGameView!)
            morseGameView!.center.y = self.frame.height/2
            morseGameView!.frame.origin.x = self.frame.width/2 - game.getPosition(for: 0.5)
            morseGameView!.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.morseGameView!.alpha = 1
                })
        }
    }
    
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0,
                                 width: Utils.maxScreen.width - 200,
                                 height: game.height))
        game.delegate = self
        addSubview(finishLine)
        finishLine.frame.size = CGSize(width: self.frame.width, height: game.height)
        finishLine.frame.origin.x = self.center.x - self.frame.width
        finishLine.center.y = center.y
        
        finishLine.backgroundColor = Colors.gray5
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

}

extension GameView: TelegraphDelegate {
    //ADD SIGNAL WHEN PUSH ON THE TELEGRAPH
    public func push() -> Completion? {
        guard let gameView = self.morseGameView else {return nil}
       
        if(game.isRunning) {
            let view = UIView()
            gameView.addSubview(view)
            
            var posX: CGFloat {
                return -gameView.frame.minX + self.frame.width/2 - game.getPosition(for: 0.5)
            }
            view.frame = CGRect(x: posX, y: 100, width: 0, height: game.getPosition(for: 1))
            view.center.y = gameView.center.y + game.getPosition(for: 1)
            view.layer.cornerRadius = game.getPosition(for: 0.5)
    
            view.backgroundColor = Colors.gray50.with(alpha: 0.25)
            
            
//            let redView = UIView()
//            gameView.addSubview(redView)
//            gameView.sendSubviewToBack(redView)
//
//            redView.frame = CGRect(x: posX, y: 100, width: 0, height: game.getPosition(for: 1))
//            redView.center.y = gameView.center.y + game.getPosition(for: 1)
//            redView.layer.cornerRadius = game.getPosition(for: 0.5)
//            redView.backgroundColor = Colors.red.with(alpha: 0.5)
            
//            var isTaped = true
            
//            func tapAnimate() {
//                UIView.animate(withDuration: game.getTime(for: 1), delay: 0, options: .curveLinear, animations: {
//                    view.frame.size.width += self.game.getPosition(for: 1)
//                    redView.frame.size.width += self.game.getPosition(for: 1)
//                }) { (true) in
//                    if isTaped {  tapAnimate() }
//                }
//            }
////
            var timer: Timer? = Timer.scheduledTimer(withTimeInterval: game.getTime(for: 0.01), repeats: true, block: { (_) in
                 view.frame.size.width += self.game.getPosition(for: 0.01)
//                 redView.frame.size.width += self.game.getPosition(for: 0.01)
            })
//            timer?.fire()
//            tapAnimate()
            return {
                timer?.invalidate()
                timer = nil
//                isTaped = false
            }
        }
        return nil
    }
    
    
}


extension GameView: GameDelegate {
    public func pause() {
        
    }
    
    public func stop(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 2, animations: {
                self.morseGameView!.frame.origin.x = self.frame.width/2 - self.game.getPosition(for: 0.5)
            })} else {
            self.morseGameView!.frame.origin.x = self.frame.width/2 - self.game.getPosition(for: 0.5)
        }
        
    }
    
    public func moveTo(ref: Int) {
        self.morseGameView?.layer.removeAllAnimations()
        
        if let signalView = self.morseGameView?.morseletterViews[ref] {
            signalView.animateColor(time: game.getTime(for: signalView.type.refSize),
                                    color: Colors.gray25,
                                    delay: game.getTime(for: 0.5))
        }
        
        if let letterView = self.morseGameView?.letterViews[ref] {
            //Ref for the width of the letter distance
            let widthRef = game.getRef(fromSize: letterView.frame.width)
            let distanceRef = letterView.letter.refSize.double - widthRef
            //Animation for letter while is being codign in morse
            //(Makes id fixed horizontally fixed)
            UIView.animate(withDuration: game.getTime(for: distanceRef),
                           delay: game.getTime(for: widthRef/2 + 0.5),
                           options: .curveLinear,
                           animations: {
                            
                            //Letter is being coding to morse
                            letterView.transform = CGAffineTransform(translationX: self.game.getPosition(for: distanceRef), y: 0)
            }, completion: { _ in
                
                //Letters is done
                UIView.animate(withDuration: 0.5, animations: {
                    letterView.alpha = 0.5
                })
            })
        }
        
        UIView.animate(withDuration: game.getTime(for: 1), delay: 0, options: .curveLinear, animations: {
            self.morseGameView?.transform = CGAffineTransform(
                translationX: -self.game.getPosition(for: ref), y: 0)
        }, completion: nil)
        
    }
    
}

//
//
//
//
//public class GameView: UIView, GameDelegate {
//
//    public var game = Game()
//
//    var finishLine = UIView()
//    public var morseGameView: MorseGameView?
//
//    public var finishedLetters: [LetterView] = []
//
//    public var letters: [MorseLetter]? {
//        didSet {
//            guard let letters = letters else { return }
//            game = Game()
//            game.delegate = self
//            morseGameView?.removeFromSuperview()
//            morseGameView = MorseGameView(game: game, letters: letters)
//            addSubview(morseGameView!)
//            morseGameView!.center.y = self.frame.height/2
//            morseGameView!.frame.origin.x = self.frame.width/2 - game.getPosition(for: 0.5)
//            morseGameView!.alpha = 0
//            UIView.animate(withDuration: 0.5, animations: {
//                self.morseGameView!.alpha = 1
//            })
//
//            //            game.start()
//
//        }
//    }
//
//
//    public init() {
//        super.init(frame: CGRect(x: 0, y: 0, width: Utils.maxScreen.width - 200,
//                                 height: game.height))
//        game.delegate = self
//        addSubview(finishLine)
//        finishLine.frame.size = CGSize(width: 60, height: game.height)
//        finishLine.center = self.center
//        finishLine.backgroundColor = Colors.gray10
//
//    }
//
//
//    public func moveTo(ref: Int) {
//        self.morseGameView?.layer.removeAllAnimations()
//
//        if let signalView = self.morseGameView?.morseletterViews[ref] {
//            signalView.animateColor(time: game.getTime(for: signalView.type.refSize),
//                                    color: Colors.gray25,
//                                    delay: game.getTime(for: 1.1))
//        }
//
//        if let letterView = self.morseGameView?.letterViews[ref] {
//            //Ref for the width of the letter distance
//            let widthRef = game.getRef(fromSize: letterView.frame.width)
//            let distanceRef = letterView.letter.refSize.double - widthRef
//            //Animation for letter while is being codign in morse
//            //(Makes id fixed horizontally fixed)
//            UIView.animate(withDuration: game.getTime(for: distanceRef),
//                           delay: game.getTime(for: widthRef/2 + 0.5),
//                           options: .curveLinear,
//                           animations: {
//
//                            //Letter is being coding to morse
//                            letterView.transform = CGAffineTransform(translationX: self.game.getPosition(for: distanceRef), y: 0)
//            }, completion: { _ in
//
//                //Letters is done
//                UIView.animate(withDuration: 0.5, animations: {
//                    letterView.setCustomColor(Colors.gray65)
//                })
//            })
//        }
//
//        UIView.animate(withDuration: game.getTime(for: 1), delay: 0, options: .curveLinear, animations: {
//            self.morseGameView?.transform = CGAffineTransform(
//                translationX: -self.game.getPosition(for: ref), y: 0)
//        }, completion: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public func moveLetterOneUnit(_ letterView: LetterView, delay: Double = 0) {
//        UIView.animate(withDuration: self.game.getTime(for: 1),
//                       delay: delay, options: [.curveLinear],
//                       animations: {
//
//                        letterView.transform = letterView.transform.concatenating(CGAffineTransform(translationX: self.game.getPosition(for: 1), y: 0))
//        }, completion: { _ in
//            self.moveLetterOneUnit(letterView)
//        })
//    }
//
//    public func pause() {
//
//    }
//
//    public func stop(animated: Bool) {
//        if animated {
//            UIView.animate(withDuration: 2, animations: {
//                self.morseGameView!.frame.origin.x = self.frame.width/2 - self.game.getPosition(for: 0.5)
//            })} else {
//            self.morseGameView!.frame.origin.x = self.frame.width/2 - self.game.getPosition(for: 0.5)
//        }
//
//    }
//
//}
//
//
