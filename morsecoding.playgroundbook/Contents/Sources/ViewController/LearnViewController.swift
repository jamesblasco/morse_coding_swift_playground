//
//  ViewController.swift
//  Morse
//
//  Created by Jaime on 14/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Foundation

public class LearnViewController: LiveViewController {
    
    public var letters: Array<LetterView> = []
    
    var longPress: UILongPressGestureRecognizer?
    var tapGR: UITapGestureRecognizer?
 
    public override func receive(_ message: PlaygroundValue) {
        
        switch message {
        case .string(let string):

            if let letter = Alphabet.dictionary[string.first!] {
                openDetailLetterView(letter: letter)
            } else {
                 self.view.backgroundColor = .random()
            }
            
            break
            
        default:
            break
        }
        
        
    }
    
   
    
    public override  func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/1024*768)
        self.view.backgroundColor = .white
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        let screenSize = UIScreen.main.bounds.size
        scrollView.frame = CGRect(x: 64, y: 64,
                                  width: screenSize.width - 128, height: screenSize.height - 128)
        
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(tapLetterAction))
        
        var newOrigin: CGPoint = .zero
        
        Alphabet.array.forEach { letter in
            let letterView = letter.createLetterView(withHeight: Size.small.letterHeight)
            let morseView = letter.createMorseView(withSize: 16)
            
            letters.append(letterView)
            letterView.addTarget(self, action: #selector(tapLetterAction))
//            letterView.tapGR = UITapGestureRecognizer(target: self, action: #selector(tapLetterAction))
//            letterView.addGestureRecognizer(letterView.tapGR!)
//
//            letterView.addGestureRecognizer(tapGR!)
//            letterView.isUserInteractionEnabled = true
            
            letterView.frame.origin = newOrigin
            morseView.frame.origin = CGPoint(x: letterView.frame.maxX + 20, y: letterView.frame.maxY - morseView.frame.height)
            
            scrollView.addSubview(letterView)
            scrollView.addSubview(morseView)
            
            newOrigin.y = letterView.frame.maxY + 25
        }
        scrollView.contentSize.height = newOrigin.y
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        
        self.view.addGestureRecognizer(longPress!)
        
//        // Do any additional setup after loading the view, typically from a nib.
//
//        example = MorseLetterView(Alphabet.A, withSize: Size.small.signalSize)
//        letter = LetterView(Alphabet.A, withHeight: Size.small.letterHeight)
//
//
//
//        self.view.addSubview(example!)
//        self.view.addSubview(letter!)
//        example?.translatesAutoresizingMaskIntoConstraints = false
//        example?.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
//        example?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
//
//        letter?.translatesAutoresizingMaskIntoConstraints = false
//        letter?.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
//        letter?.bottomAnchor.constraint(equalTo: self.example!.topAnchor, constant: -16).isActive = true
    }
    
    
    @objc public func tapLetterAction(_ sender: UITapGestureRecognizer)  {
       print("tapped")
        guard let letterView = sender.view as? LetterView else { return }
        openDetailLetterView(letter: letterView.letter)
    }
    
    
    func openDetailLetterView(letter: MorseLetter) {
        let vc = LetterDetailViewController(letter: letter)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: true, completion: nil)
    }
    
    @objc public func longPressAction(_ sender: UILongPressGestureRecognizer)  {
        UIView.animate(withDuration: 0.5) {
            self.letters.forEach { letterView in
                if (sender.state == .began) {
                   letterView.setMorseMode()
                } else {
                    letterView.setNormalMode()
                }
            }
           
        }
     
    }

}

