
//
//  Telegraph.swift
//  Morse
//
//  Created by Jaime on 17/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit


public protocol TelegraphDelegate {
    func push() -> Completion?
}


public class TelegraphView: UIImageView {
    
    public var delegate: TelegraphDelegate?
    public var toneAudioUnit = ToneAudioUnit.shared
    
     var tapableView = UIView()
    var topShadowButton = UIImageView()
    var bottomShadowButton = UIImageView()
    var button = UIImageView()
    var shadowBar = UIImageView()
    var bar = UIImageView()
    
   
    public init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        image = UIImage(named: "telegraph_base")
        
        bar.contentMode = .scaleAspectFit
        bar.image = UIImage(named: "telegraph_bar")
       
        shadowBar.contentMode = .scaleAspectFit
        shadowBar.image = UIImage(named: "telegraph_bar_shadow")
        shadowBar.alpha = 0.8
        
        //         bar.frame.size = CGSize(width: 20, height: 100)
        
        topShadowButton.contentMode = .scaleAspectFit
        topShadowButton.image = UIImage(named: "telegraph_shadow")
        topShadowButton.alpha = 0.75
       
        bottomShadowButton.contentMode = .scaleAspectFit
        bottomShadowButton.image = UIImage(named: "telegraph_shadow")
       
        bottomShadowButton.alpha = 0.5
        addSubview(shadowBar)
        addSubview(bottomShadowButton)
        addSubview(bar)
        addSubview(topShadowButton)
        addSubview(button)
        button.contentMode = .scaleAspectFit
        button.image = UIImage(named: "telegraph_button")
       
        
        addSubview(tapableView)
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapButton))
        tap.minimumPressDuration = 0
        tapableView.isUserInteractionEnabled =  true
        tapableView.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        toneAudioUnit.enableSpeakerIfNedded()
        toneAudioUnit.play(tone: .A4)
        toneAudioUnit.setToneVolume(vol: 0)
        updateFrame()
    }
    
    
    func updateFrame() {
        
       let width =  frame.size.width
       let height =   width * image!.size.height / image!.size.width
        frame.size = CGSize(width: width, height: height)
        
//        let width =  frame.size.width
//        let height =  frame.size.height
        
        let centerX =  width/2
        let buttonSize = width*0.4
        let buttonMargin = (frame.size.width - buttonSize)/2
        let buttonCenterY = buttonSize/2 + 2*buttonMargin/3
        button.frame.size = CGSize(width: buttonSize, height: buttonSize)
        button.center = CGPoint(x: centerX, y: buttonCenterY)
        
        tapableView.frame.size = CGSize(width: 3*buttonSize/2, height: 3*buttonSize/2)
        tapableView.center = CGPoint(x: centerX, y: buttonCenterY)
        
        let barWidth = width/5
        let barHeight = barWidth * bar.image!.size.height / bar.image!.size.width
        bar.frame.size = CGSize(width: barWidth, height: barHeight)
        bar.frame.origin.y = buttonCenterY
        bar.center.x = centerX
        
        shadowBar.frame.size = CGSize(width: barWidth + 40, height: barHeight + 40)
        shadowBar.center = bar.center
        
        let shadowSize = CGSize(width: buttonSize + 64,
                                height: buttonSize + 64)
        let shadowCenter = CGPoint(x: centerX,
                                   y: buttonCenterY + 4)
        
        topShadowButton.frame.size = shadowSize
        topShadowButton.center = shadowCenter
        bottomShadowButton.frame.size = shadowSize
        bottomShadowButton.center = shadowCenter
    }
    
    var timer: Timer?
    var endTouch: Completion?
    
    @objc public func tapButton(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let timer = timer {
                timer.invalidate()
            } else {
                endTouch = delegate?.push()
                toneAudioUnit.setToneVolume(vol: 0.5)
                UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseInOut, animations: {
                    self.button.transform = CGAffineTransform(scaleX: 0.90, y: 0.90).translatedBy(x: 0, y: 8)
                    self.topShadowButton.transform = CGAffineTransform(scaleX: 0.90, y: 0.90).translatedBy(x: 0, y: 8)
                    self.bottomShadowButton.transform = CGAffineTransform(scaleX: 0.98, y: 0.98).translatedBy(x: 0, y: 16)
                    self.bar.transform = CGAffineTransform(scaleX: 0.98, y: 1).translatedBy(x: 0, y: 4)
                    self.shadowBar.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
                    
                    self.shadowBar.layer.transform = CATransform3DScale(CATransform3DMakeRotation(.pi*0.25, 1, 0, 0), 2, 2, 0.90)
                    self.bar.layer.transform =  CATransform3DScale(CATransform3DMakeRotation(.pi*0.25, 1, 0, 0), 1, 1, 0.90)
                    
                })
            }
           
        
        case .cancelled, .failed, .ended:
           timer =  Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block:
                {_ in
                    self.endTouch?()
                    self.endTouch = nil
                    self.toneAudioUnit.setToneVolume(vol: 0)
                    self.button.layer.removeAllAnimations()
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                        self.button.transform = .identity
                        self.bottomShadowButton.transform = .identity
                        self.topShadowButton.transform = .identity
                        self.bar.transform = .identity
                        self.shadowBar.transform =  .identity
                        self.shadowBar.layer.transform =  CATransform3DIdentity
                        self.bar.layer.transform =  CATransform3DIdentity
                    })
                    self.timer = nil
            })
        default: break
            
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

