//
//  Dot.swift
//  Morse
//
//  Created by Jaime on 14/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit

public class LetterView: TapableImageView {
    
    public var height: CGFloat { didSet {
        updateHeight(height)
    }}
    
    public var color: UIColor
    public var letter: MorseLetter
 
    
    public func setCustomColor(_ color: UIColor) {
        self.tintColor = color
    }
    
    
    public init(_ letter: MorseLetter,
         withHeight height: CGFloat) {
    
        self.color = letter.color
        self.height = height
        self.letter = letter
        super.init(frame: .zero)
        
        self.image = letter.image
        
        self.tintColor = letter.color
    
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    
        
       updateHeight(height)
    }
    
    public func updateHeight(_ heigth: CGFloat){
        let width = (image?.size.width ?? 0) * height / (image?.size.height ?? 1)
        self.frame.size = CGSize(width: width, height: height)
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setMorseMode(){
        self.image = letter.morseImage
    }
    
    public func setGreyMode(){
        self.image = letter.greyImage
    }
    public func setNormalMode(){
        self.image = letter.image
    }
    
    
    
}

public class MorseLetterView: UIView {
    public var signalViews: Array<MorseSignalView>
    public var size: CGFloat
    
    public var color: UIColor
    public var signals: Array<Signal>
    
    public init(_ letter: MorseLetter,
         withSize size: CGFloat) {
        
        self.signalViews = []
        self.signals = letter.code
        self.color = letter.color
        self.size = size
        
        super.init(frame: .zero)
        
        let spaceSize = size
        var newOrigin = CGPoint.zero
    
        signals.forEach { signal in
            let signalView = MorseSignalView(type: signal, color: color, withSize: size)
            signalViews.append(signalView)
            addSubview(signalView)
            
            signalView.frame.origin = newOrigin
            newOrigin.x = newOrigin.x + signalView.frame.width + spaceSize
        }
        
        let width = newOrigin.x - spaceSize
        self.frame.size = CGSize(width: width, height: size)
        self.center = CGPoint(x: width/2, y: size/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func showSignals() {
        
    }
}


public class MorseSignalView: UIView {
    
    public var type: Signal
    public var color: UIColor
    
    public var animView = UIView()

    required public init(type: Signal, color: UIColor, withSize size: CGFloat) {
       
        self.type = type
        self.color = color
        
        let width = type == .dot ? size : size * 3
        super.init(frame: CGRect(origin: .zero,
                                 size: CGSize(width: width,
                                              height: size)))
        self.backgroundColor = color
        self.layer.cornerRadius = size/2
        addSubview(animView)
        clipsToBounds = true
    }
    
    public func animateColor(time: Double, color: UIColor, delay: Double = 0){
        animView.alpha = 1
        animView.backgroundColor = color
        animView.frame.size = CGSize(width: 0, height: frame.width)
        UIView.animate(withDuration: time, delay: delay, options: .curveLinear, animations: {
            self.animView.frame.size = self.frame.size
        }, completion: nil)
    }
    
    public func hideAnimatedColor() {
        UIView.animate(withDuration: 0.3, animations: {
            self.animView.alpha = 0
            
        })
    }
    
    func showShadow() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


















enum Size {
    case small
    case medium
    case big
    
    var signalSize: CGFloat {
        switch self {
        case .small: return 20
        case .medium: return 35
        case .big: return 35
        }
    }
    
    var letterHeight: CGFloat {
        switch self {
            case .small: return 48
            case .medium: return 90
            case .big: return 180
        }
    }
}
//
//
//
//class MorseLetterView: UIView {
//    var signalViews: Array<MorseSignalView>
//    var signals: Array<Signal>
//    var size: Size
//
//    init(signals: Array<Signal>,
//         withSize size: Size) {
//        self.signalViews = []
//        self.signals = signals
//        self.size = size
//        super.init(frame: .zero)
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.heightAnchor.constraint(equalToConstant: size.rawValue).isActive = true
//
//        var last: MorseSignalView?
//
//        signals.forEach { signal in
//            let signalView = MorseSignalView(type: signal, withSize: size)
//            addSubview(signalView)
//            signalView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//            signalViews.append(signalView)
//
//            if last == nil {
//                signalView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//            } else {
//                signalView.leftAnchor.constraint(equalTo: last!.rightAnchor, constant: size.rawValue/2).isActive = true
//            }
//            last = signalView
//        }
//        last?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    func showSignals() {
//
//    }
//}
//
//
//class MorseSignalView: UIView {
//
//
//
//    required init(type: Signal, withSize size: Size) {
//        let width = type == .dot ? size.rawValue : size.rawValue * 3
//        let height = size.rawValue
//
//        super.init(frame: CGRect(origin: .zero,
//                                 size: CGSize(width: width,
//                                              height: height)))
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.heightAnchor.constraint(equalToConstant: height).isActive = true
//        self.widthAnchor.constraint(equalToConstant: width).isActive = true
//        self.backgroundColor = .black
//        self.layer.cornerRadius = height/2
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


//
//class Dot: UIView {
//    
//    var size: Size { didSet {
//        self.heightAnchor.constraint(equalToConstant: size.rawValue)
//        self.widthAnchor.constraint(equalToConstant: size.rawValue)
//    }}
//
//    required init(withSize size: Size) {
//        self.size = size
//        super.init(frame: CGRect(origin: .zero,
//                                 size: CGSize(width: size.rawValue,
//                                              height: size.rawValue)))
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//class Dash: UIView {
//
//    var size: Size { didSet {
//        self.heightAnchor.constraint(equalToConstant: size.rawValue)
//        self.widthAnchor.constraint(equalToConstant: size.rawValue * 3)
//    }}
//    
//    required init(withSize size: Size) {
//        self.size = size
//        super.init(frame: CGRect(origin: .zero,
//                                 size: CGSize(width: size.rawValue*3,
//                                              height: size.rawValue)))
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//
//
//public class LetterView: TapableImageView {
//    public var height: CGFloat { didSet {
//        updateHeight(height)
//        }}
//    public var color: UIColor
//    public var letter: MorseLetter
//
//    public func setCustomColor(_ color: UIColor) {
//        self.tintColor = color
//    }
//
//
//
//
//    public init(_ letter: MorseLetter,
//                withHeight height: CGFloat) {
//
//        self.color = letter.color
//        self.height = height
//        self.letter = letter
//        super.init(frame: .zero)
//
//        self.image = letter.image
//
//        self.tintColor = letter.color
//
//        self.contentMode = .scaleAspectFit
//        self.clipsToBounds = false
//        self.layer.masksToBounds = false
//
//        updateHeight(height)
//    }
//
//    public func updateHeight(_ heigth: CGFloat){
//        let width = (image?.size.width ?? 0) * height / (image?.size.height ?? 1)
//        self.frame.size = CGSize(width: width, height: height)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public func setMorseMode(){
//        self.image = letter.morseImage
//    }
//    public func removeMorseMode(){
//        self.image = letter.image
//    }
//
//
//
//}
