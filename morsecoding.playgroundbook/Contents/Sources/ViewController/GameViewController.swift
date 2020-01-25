//
//  GameViewController.swift
//  Morse
//
//  Created by Jaime on 17/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

public typealias Completion = () -> Void
public typealias Completions = [Completion]

import UIKit
import PlaygroundSupport

public class GameViewController: LiveViewController {

    var screenSize: CGSize!
    public var telegraph = TelegraphView()
    public var gameView = GameView()
    var ready = UIImageView()
    var steady =  UIImageView()
    var go =  UIImageView()
   

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.screenSize = self.view.frame.size
        print(Utils.screenSize)
        
        self.view.backgroundColor = .white
    
        self.view.addSubview(gameView)
        
        addBorders()

        ready.contentMode = .scaleAspectFit
        steady.contentMode = .scaleAspectFit
        go.contentMode = .scaleAspectFit
        ready.image = UIImage(named: "Ready")
//        ready.backgroundColor = .random()
        steady.image = UIImage(named: "Steady")
        go.image = UIImage(named: "GO")
        
         self.view.addSubview(ready)
         self.view.addSubview(steady)
         self.view.addSubview(go)
        
        updateFrames()
    
        self.view.addSubview(telegraph)
        telegraph.delegate = gameView
        
//        telegraph.frame.origin.y = screenSize.height + telegraph.frame.height*2
//        telegraph.center.x = self.view.center.x
        
//        ready.transform = CGAffineTransform(scaleX: 0, y: 0)
//        steady.transform = CGAffineTransform(scaleX: 0, y: 0)
//        go.transform = CGAffineTransform(scaleX: 0, y: 0)
        
     
    }
    
    func updateFrames()  {
        self.gameView.center = self.view.center
        self.gameView.center.y =  self.gameView.center.y - 100.0

        topBorder.frame.size = CGSize(width: screenSize.width,
                                      height: gameView.frame.minY)
        
        bottomBorder.frame.size = CGSize(width: screenSize.width,
                                         height: screenSize.height - gameView.frame.maxY)
        topBorder.frame.origin = .zero
        bottomBorder.frame.origin = CGPoint(x: 0, y: gameView.frame.maxY)
        
        let telegraphWidth = (screenSize.height+screenSize.width)/5
        self.telegraph.frame.size = CGSize(width: telegraphWidth,
                                           height: telegraphWidth)
        self.telegraph.updateFrame()
        self.telegraph.frame.origin.y = screenSize.height - 3*self.telegraph.frame.height/4
        self.telegraph.center.x = screenSize.width * 3/4        
    }
    
    
    func animCountdown(_ view: UIView, double: Bool = false) {
         view.frame.size = .zero
         view.center = self.gameView.center
         view.alpha = 1

        if !double {
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
                view.frame.size =  CGSize(width: self.screenSize.width/2,
                                          height: self.screenSize.height/2)
                
                view.center = self.gameView.center
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    view.frame.size = .zero
                    view.center = self.gameView.center
                }, completion: { _ in })
            })
        } else {
            UIView.animate(withDuration: 0.9, delay: 0, options: [.curveEaseIn], animations: {
                view.frame.size = CGSize(width: self.screenSize.width*2,
                                         height: self.screenSize.height*2)
                
                view.center = self.gameView.center
            }, completion: { _ in })
        }
            
        UIView.animate(withDuration: 0.3, delay: 0.6, options: .curveEaseIn, animations: {
            view.alpha = 0
        }, completion: { _ in })
  
    }
    
    func invalidateCoutDown() {
        timers.forEach { (key,timer) in
            timer?.invalidate()
            var time = timers[key]
            time = nil
            timers[key] = time
        }
        ready.layer.removeAllAnimations()
        steady.layer.removeAllAnimations()
        go.layer.removeAllAnimations()
       
        self.ready.frame.size = .zero
        self.ready.center = self.gameView.center
        self.ready.alpha = 1
        self.steady.frame.size = .zero
        self.steady.center = self.gameView.center
        self.steady.alpha = 1
        self.go.frame.size = .zero
        self.go.center = self.gameView.center
        self.go.alpha = 1
        
    }
    
    var timers: [Int:Timer?] = [:]

    func start() {
        animCountdown(ready)
        timers[1] = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { (Timer) in
            self.animCountdown(self.steady)
        }
        timers[2] = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { (Timer) in
            self.animCountdown(self.go, double: true)
        }
        timers[3] = Timer.scheduledTimer(withTimeInterval: 2.2, repeats: false) { (Timer) in
            self.gameView.game.start()
        }
//        self.view.addSubview(ready)
//        self.view.addSubview(steady)
//        self.view.addSubview(go)
//        
//        ready.frame.size =  CGSize(width: self.screenSize.width/2,
//                                   height: self.screenSize.height/2)
//        steady.frame.size  = CGSize(width: self.screenSize.width/2,
//                                    height: self.screenSize.height/2)
//        go.frame.size = CGSize(width: self.screenSize.width/2,
//                               height: self.screenSize.height/2)
//        
//        ready.center = self.gameView.center
//        steady.center = self.gameView.center
//        go.center = self.gameView.center
//        
//        self.go.alpha = 1
//        
//        ready.transform = CGAffineTransform(scaleX: 0, y: 0)
//        steady.transform = CGAffineTransform(scaleX: 0, y: 0)
//        go.transform = CGAffineTransform(scaleX: 0, y: 0)
//
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
//            self.ready.transform = .identity
//        }, completion: { _ in
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//                self.ready.frame.size = .zero
//                self.ready.center = self.gameView.center
//            }, completion: { _ in
//                
//            })
//
//        })
//
//        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
//            self.steady.transform = .identity
//        }, completion: { _ in
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//                self.steady.frame.size = .zero
//                self.steady.center = self.gameView.center
//            }, completion: { _ in
////                self.steady.removeFromSuperview()
//            })
//            
//        })
//
//        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseIn, animations: {
//            self.go.transform = .identity
//            self.go.frame.size = CGSize(width: self.screenSize.width * 2,
//                                        height: self.screenSize.height*2)
//            self.go.center = self.gameView.center
//            
//        }, completion: { _ in
//        })
//        
//        UIView.animate(withDuration: 0.5, delay: 2.5, options: .curveEaseIn, animations: {
//           self.go.alpha = 0
//        }, completion: { _ in
//        })
//    
    }
    

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let center =  self.telegraph.frame.origin.y
        self.telegraph.frame.origin.y = center + self.telegraph.frame.height
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseInOut, animations: {
            self.telegraph.frame.origin.y =  center
        }, completion: nil)
  
        
    }
    
    
    
    let topBorder = UIView()
    let bottomBorder = UIView()
    var timeRatio = 5
    var message = ""
    
    public override func receive(_ message: PlaygroundValue) {
        if case .integer(let value) = message  {
             timeRatio = value
        }
        
        if case .string(let string) = message  {
//        string.encode(to: Encoder)
            self.message = string
            resetGame()
            timers[0] = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
                self.start()
            }
        }
        
        

    }
    
    func resetGame(animated: Bool = false) {

        if gameView.game.isStarting {
            invalidateCoutDown()
        }
        
        if gameView.game.isRunning {
            gameView.game.stop(animated: animated)
        }
        
        gameView.game.isStarting = true
        gameView.letters = message.encodeToMorse()
        gameView.game.timeRatio = 1.0/Double(max(1, timeRatio))
        
        send(.boolean(true))
      
        
    }
    
    public override func liveViewMessageConnectionClosed() {
         resetGame(animated: true)
    }


    public func addBorders() {
       
        topBorder.backgroundColor = Colors.gray10
        
        topBorder.layer.shadowColor = UIColor.black.cgColor
        topBorder.layer.shadowOffset = CGSize(width: 0, height: 4)
        topBorder.layer.shadowRadius = 12
        topBorder.layer.shadowOpacity = 0.2
        topBorder.clipsToBounds = false
        
        self.view.addSubview(topBorder)
    
        bottomBorder.backgroundColor = Colors.gray10
      
        
        bottomBorder.layer.shadowColor = UIColor.black.cgColor
        bottomBorder.layer.shadowOffset = CGSize(width: 0, height: -4)
        bottomBorder.layer.shadowRadius = 12
        bottomBorder.layer.shadowOpacity = 0.2
        bottomBorder.clipsToBounds = false
   
        self.view.addSubview(bottomBorder)
        

    }
    
    
   
    

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        if screenSize != self.view.frame.size {
        
            screenSize = self.view.frame.size
            //            self.view.backgroundColor = .random()
            updateFrames()
          
        }
        // Layout here.
    }
}

