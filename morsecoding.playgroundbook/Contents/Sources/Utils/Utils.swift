//
//  Utils.swift
//  Morse
//
//  Created by Jaime on 16/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import UIKit


class Utils {
    static var screenSize: CGSize { return UIScreen.main.bounds.size }
    static var minScreen = CGSize(width: 1024, height: 768)
    static var maxScreen = CGSize(width: 1366, height: 1024)
}



public class Colors {
    public static let gray5 = UIColor(0xFAFAFA)
    public static let gray10 = UIColor(0xEFEFEF)
    public static let gray25 = UIColor(0xDADADA)
    public static let gray50 = UIColor(0xA6A6A6)
    public static let gray65 = UIColor(0x767676)
    public static let gray85 = UIColor(0x474747)
    public static let red = UIColor(0xEA1517)
}

extension UIColor {
    public convenience init(_ hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    public func with(alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
}



extension Int {
    public var double: Double {return Double(self)}
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}




extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}



public class TapableView: UIView {
    
    var tapGR: UITapGestureRecognizer?
    
    public func addTarget(_ target: Any?, action: Selector) {
        tapGR = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGR!)
    }
}

public class TapableImageView: UIImageView {
    
    var tapGR: UITapGestureRecognizer?
    
    public func addTarget(_ target: Any?, action: Selector) {
        tapGR = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGR!)
        isUserInteractionEnabled = true
    }
}



extension String {
    public func  encodeToMorse() -> [MorseLetter]{
        var letters: [MorseLetter] = []
        for char in self.uppercased() {
            if let letter = Alphabet.dictionaryWithSpace[char] {
                if char == " " {
                    letters.append(letter)
                }
                letters.append(letter)
            }
        }
        return letters
    }
    
    public var cleared: String {
        return self.replacingOccurrences(of: "/*#-editable-code*/", with: "")
            .self.replacingOccurrences(of: "<#T##", with: "")
            .self.replacingOccurrences(of: "##String#>", with: "")
            .self.replacingOccurrences(of: "/*#-end-editable-code*/", with: "")
     
    }
}
