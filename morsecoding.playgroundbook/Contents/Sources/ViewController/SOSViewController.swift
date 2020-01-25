//
//  SOSViewController.swift
//  Book_Sources
//
//  Created by Jaime on 20/03/2019.
//

import UIKit
import PlaygroundSupport
import Foundation

public class SOSViewController: LiveViewController {
    
    public var letters: Array<LetterView> = []

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
    
    
     let scrollView = UIScrollView()
    public override  func viewDidLoad() {
        super.viewDidLoad()
        self.screenSize = self.view.frame.size
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
    
        tapGR = UITapGestureRecognizer(target: self, action: #selector(tapLetterAction))
    
        Alphabet.array.forEach { letter in
            let letterView = letter.createLetterView(withHeight: Size.medium.letterHeight)
            scrollView.addSubview(letterView)
            letters.append(letterView)
            letterView.addTarget(self, action: #selector(tapLetterAction))
            letterView.setMorseMode()
        }
        
        logo.image = UIImage(named: "Morse")
        logo.contentMode = .scaleAspectFit
        scrollView.addSubview(logo)
        updateFrame()
     
    }
    var logo = UIImageView()
    var borderView = UIView()
    

    
    func updateFrame() {
        self.scrollView.backgroundColor = Colors.gray5
//        if (self.view.frame)
        let average = (screenSize.width + screenSize.height)/2
        logo.frame.size = CGSize(width: screenSize.width, height: average/16)
        logo.center = CGPoint(x: screenSize.width/2, y: screenSize.height/8)
        
        scrollView.frame = self.view.frame
        scrollView.center = self.view.center
        let padding: CGFloat = 1/8 * screenSize.width
        let minSize: CGFloat = min(screenSize.width, screenSize.height)
        let width = (minSize - padding*2)/4
        let height = 2*width/3
        
        let margin: CGFloat = 80
        
        letters.forEach { $0.height = height }
        
        var newOrigin: CGPoint = CGPoint(x: width/2 + padding,
                                         y: height/2 + padding + logo.frame.maxY)
        
        var maxX: CGFloat = 0
        let columns = Int((screenSize.width - 2*padding)/(width))
//        if columns == 0 { columns = 1 }
        
        letters.enumerated().forEach { (index, letterView) in
            if index % columns == 0  && index != 0{
                newOrigin = CGPoint(x: width/2  + padding,
                                    y: newOrigin.y + height + margin )
            }
            letterView.center = newOrigin
            newOrigin.x += width
            maxX = max(maxX, letterView.frame.maxX)
        }
        
        scrollView.contentSize = CGSize(width: maxX,
                                        height: letters.last!.frame.maxY + padding)
         print(scrollView.contentSize)
      
        
    }
    
    var screenSize: CGSize!
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if screenSize != self.view.frame.size  && self.view.frame.size != .zero {
            screenSize = self.view.frame.size
            //            self.view.backgroundColor = .random()
            updateFrame()
            
        }
        // Layout here.
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
    
  
    
}

