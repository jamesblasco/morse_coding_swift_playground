//
//  GameModel.swift
//  Morse
//
//  Created by Jaime on 20/03/2019.
//

import UIKit
import PlaygroundSupport

public protocol GameDelegate {
    func moveTo(ref: Int)
    func pause()
    func stop(animated: Bool)
}


public func calculateTime(message: String, timeRatio:  Double, _ completion: Completion?) {
    let letters = message.encodeToMorse()
    var ref = 6
    letters.forEach { letter in
        ref += letter.refSize + 3
    }
    ref += -3 + 4
    Timer.scheduledTimer(withTimeInterval: Double(ref)*timeRatio + 3.2, repeats: false) { (_) in
        completion?()
    }
}

/* A reference represents a dot in space and time */

public class Game {
    
    public var isRunning: Bool = false
    public var isStarting: Bool = true
    
    public var timeRatio: Double = 0.2
    private var spaceRatio: CGFloat = 50
    public var height: CGFloat = 400
    
    public var timer: Timer!
    
    public var currentReference = 0
    
    public var startReference = 6
    public var endReference = 4
    public var referencesCount = 40
    
    public var letters: [MorseLetter]? {
        didSet {
            guard let letters = letters else {return}
            var ref = startReference
            letters.forEach { letter in
                ref += letter.refSize + 3
            }
            ref += -3 + endReference
            referencesCount = ref
        }
    }
    
    public var delegate: GameDelegate?
    public init() {
        
    }
    
    public func start() {
        if isRunning { stop(animated: false) }
        isStarting = false
        isRunning = true
        timer = Timer.scheduledTimer(timeInterval: timeRatio, target: self, selector: #selector(nextStep), userInfo: nil, repeats: true)
        nextStep()
    }
    
    public func stop(animated: Bool) {
        isRunning = false
        timer.invalidate()
        delegate?.stop(animated: animated)
        currentReference = 0
    }
    
    public func end() {
        
        isRunning = false
        timer.invalidate()
//        PlaygroundPage.current.assessmentStatus = .pass(message: "**Congratulations!** You sent your first morse message.")
//        PlaygroundPage.current.finishExecution()
    }
    
    public func pause() {
        isRunning = false
        timer.invalidate()
        delegate?.pause()
    }
    
    
    @objc public  func nextStep() {
        
        currentReference = currentReference + 1
        
        if currentReference < (referencesCount) {
            print(currentReference)
            delegate?.moveTo(ref: currentReference)
        } else {
            end()
            
        }
    }
    
    public func getPosition(for reference: Int) -> CGFloat {
        return spaceRatio * CGFloat(reference)
    }
    public func getPosition(for reference: Double) -> CGFloat {
        return spaceRatio * CGFloat(reference)
    }
    
    public func getTime(for reference: Int) -> Double {
        return timeRatio * Double(reference)
    }
    
    public func getTime(for reference: Double) -> Double {
        return timeRatio * reference
    }
    
    public func getRef(fromSize size: CGFloat) -> Double {
        return Double(size / spaceRatio)
    }
    
    public func getRef(fromTime time: Double) -> Double {
        return time / timeRatio
    }
    
    
    
    
    
}


