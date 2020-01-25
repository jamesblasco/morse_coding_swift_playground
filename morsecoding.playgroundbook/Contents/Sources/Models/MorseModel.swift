//
//  File.swift
//  Morse
//
//  Created by Jaime on 14/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit

// Enumeration that represents each signal, it can be a dot that is one unit of time or dash that represents three units of time

public enum Signal: Int {
    case dot = 1, dash = 3
    public var refSize : Int {return self.rawValue}
}

public struct MorseLetter {
    public var char: Character
    public var code: Array<Signal>
    public var color: UIColor = .black
    public var tone: Tone = .A4
    
    
    public init(_ char: Character,
         code: Array<Signal>) {
        self.code = code
        self.char = char
    }
    public init(_ char: Character,
         code: Array<Signal>,
         color: UInt = 0x000000, tone: Tone) {
        self.char = char
        self.code = code
        self.color = UIColor(color)
        self.tone = tone
    }
    
    public var refSize: Int {
        return code.reduce(0) { $0 + $1.refSize} + code.count - 1
    }
    
    public var image: UIImage? {
        return UIImage(named: "\(char)")
        
    }
    public var morseImage: UIImage? { return UIImage(named: "\(char)_Morse")}
     public var greyImage: UIImage? { return UIImage(named: "\(char)_Grey")}
    
    public func createLetterView(withHeight height: CGFloat) -> LetterView {
        return LetterView(self, withHeight: height)
    }
    public func createMorseView(withSize size: CGFloat) -> MorseLetterView {
        return MorseLetterView(self, withSize: size)
    }
}

typealias Word = [MorseLetter]
typealias Sentence = [Word]

