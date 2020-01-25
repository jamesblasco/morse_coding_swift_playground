//
//  LetterDetailViewController.swift
//  Morse
//
//  Created by Jaime on 16/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit
import PlaygroundSupport

public class LetterDetailViewController: UIViewController {
    
    
    var screenSize: CGSize!
    let backgound = UIView()
    public var letter: MorseLetter
    
    public init(letter: MorseLetter) {
        self.letter = letter
        super.init(nibName: nil, bundle: nil)
        self.screenSize = self.view.frame.size
        self.view.backgroundColor = .white
        
        self.view.addSubview(backgound)
        backgound.backgroundColor = Colors.gray10
       
        setCard()
        updateFrames()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateFrames() {
        
        backgound.frame = CGRect(x: 0, y: 0,
                                 width: screenSize.width, height: screenSize.height/2)
        
        let minPadding = CGPoint(x: 64,
                                 y: screenSize.height > screenSize.width ? 100 : 80)
        let width = min(Utils.minScreen.width, screenSize.width - minPadding.x * 2)
        let heigth = min(Utils.minScreen.height, screenSize.height - minPadding.y * 2)
        cardView.frame.size = CGSize(width: width, height: heigth)
        cardView.center = self.view.center
        snapping.snapPoint = self.view.center
        
        cardView.updateFrame()
    }
    
    public var cardView: CardView!
    private var animator: UIDynamicAnimator!
    private var snapping: UISnapBehavior!
    private var cardViewPanGesture: UIPanGestureRecognizer!
    
    public func setCard() {
       
        cardView = CardView(letter: letter, frame: .zero)
        self.view.addSubview(cardView)
        
        self.snapping = UISnapBehavior(item: self.cardView, snapTo: view.center)
        animator = UIDynamicAnimator(referenceView: view)
        cardView.frame.origin = CGPoint(x: cardView.frame.origin.x,
                                        y: cardView.frame.origin.y + Utils.screenSize.height)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedCard))
        cardView.addGestureRecognizer(panGesture)
        //        cardView?.frame = CGRect(x: 64, y: 128 + size.height,
        //                                              width: size.width - 128, height: size.height - 256)
        
    }

    
    public func appearCard() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            guard let cardView = self.cardView else {return}
            var frame = cardView.frame
            frame.origin = CGPoint(x: cardView.frame.minX ,
                                    y: (self.view.frame.height - cardView.frame.height)/2)
            self.cardView?.frame = frame
        }, completion: { (_) in
            self.cardView.isUserInteractionEnabled = true
            self.animator.addBehavior(self.snapping)
        })
        
    }
    
    @objc public  func pannedCard(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            animator.removeBehavior(snapping)
            cardView.transform = .identity
        case .changed:
            let translation = sender.translation(in: cardView)
            cardView.center = CGPoint(x: cardView.center.x + translation.x,
                                      y: max(cardView.center.y + translation.y, self.view.center.y - 24))
            let rotate = translation.x / self.view.frame.width * .pi / 4
            cardView.transform = cardView.transform.concatenating(CGAffineTransform(rotationAngle: rotate))
            
            sender.setTranslation(.zero, in: view)
            break
        case .possible, .cancelled: break
        default:
            animator.addBehavior(snapping)
        }
        
        if (cardView.center.x > 3 / 4 * self.view.frame.width ||
            cardView.center.y > 3 / 5 * self.view.frame.height ||
            cardView.center.x < 1 / 4 * self.view.frame.width )
        {
            
            sender.isEnabled = false
            animator.removeBehavior(snapping)
            UIView.animate(withDuration: 0.5, animations: {
                
                let translationX = (self.view.center.x - self.cardView.center.x) * 4
                let translationY =  (self.view.center.y - self.cardView.center.y) * 4
                
                let rotate = translationX / self.view.frame.width * .pi / 4
                self.cardView.transform = self.cardView.transform.concatenating(CGAffineTransform(rotationAngle: rotate))
                
                self.cardView.center = CGPoint(x: self.cardView.center.x + translationX,
                                               y: self.cardView.center.y + translationY)
            }, completion: { (_) in
                self.cardView.morsePlayerView.detach()
                self.cardView.removeFromSuperview()
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.fade
                transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.dismiss(animated: true, completion: nil)
            })
        }
//          if (  cardView.center.x < Utils.screenSize.width / 3  ||
//            cardView.center.x <  Utils.screenSize.width / 3) {
//            animator.removeBehavior(snapping)
//            UIView.animate(withDuration: 2, animations: {
//                let translation = sender.translation(in: self.cardView)
//                self.cardView.center = CGPoint(x: self.cardView.center.x * 2,
//                                               y: self.cardView.center.y * 2)
//            }, completion: { (_) in
//                self.cardView.removeFromSuperview()
//            })

        
    
//        }
    }
    
    override public  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        appearCard()
        
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if screenSize != self.view.frame.size {
             animator.removeBehavior(snapping)
            screenSize = self.view.frame.size
//            self.view.backgroundColor = .random()
            updateFrames()
            animator.addBehavior(snapping)
        }
        // Layout here.
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
       
//        setCardSize(size: size)

    }
    
}


