//
//  Alphabet.swift
//  Morse
//
//  Created by Jaime on 16/03/2019.
//  Copyright © 2019 jaimeblasco.com. All rights reserved.
//

import Foundation





public enum Letter: String {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case K = "K"
    case L = "L"
    case M = "M"
    case N = "N"
    case O = "O"
    case P = "P"
    case Q = "Q"
    case R = "R"
    case S = "S"
    case T = "T"
    case U = "U"
    case V = "V"
    case W = "W"
    case X = "X"
    case Y = "Y"
    case Z = "Z"
}

public class Alphabet {
   public static let A = MorseLetter("A",
                          code: [.dot, .dash],
                          color: 0xE67839,
                          tone: .A4)
    
    public static let B = MorseLetter("B",
                          code: [.dash, .dot, .dot, .dot],
                          color: 0x973D97,
                          tone: .B4)
    
    public static let C = MorseLetter("C",
                          code: [.dash, .dot, .dash, .dot],
                          color: 0x3E4DE1,
                          tone: .C4)
    public static let D = MorseLetter("D",
                          code: [.dash, .dot, .dot],
                          color: 0xEA1517,
                          tone: .D4)
    public static let E = MorseLetter("E",
                          code: [.dot],
                          color: 0x04505E,
                          tone: .E4)
    public static let F = MorseLetter("F",
                          code: [.dot, .dot, .dash, .dot],
                          color: 0xA03F00,
                          tone: .F4)
    public static let G = MorseLetter("G",
                          code: [.dash, .dash, .dot],
                          color: 0x0A8449,
                          tone: .G4)
    public static let H = MorseLetter("H",
                          code: [.dot, .dot, .dot, .dot],
                          color: 0x103AAA,
                          tone: .A5)
    public static let I = MorseLetter("I",
                          code: [.dot, .dot],
                          color: 0x973D95,
                          tone: .B5)
    public static let J = MorseLetter("J",
                          code: [.dot, .dash, .dash, .dash],
                          color: 0xFFDE00,
                          tone: .C5)
    public static let K = MorseLetter("K",
                          code: [.dash, .dot, .dash],
                          color: 0x10077E,
                          tone: .D5)
    public static let L = MorseLetter("L",
                          code: [.dot, .dash, .dot, .dot],
                          color: 0x060604,
                          tone: .E5)
    public static let M = MorseLetter("M",
                          code: [.dash, .dash],
                          color: 0xF3610C,
                          tone: .F5)
    public static let N = MorseLetter("N",
                          code: [.dash, .dot],
                          color: 0x8DBC0F,
                          tone: .G5)
    public static let O = MorseLetter("O",
                          code: [.dash, .dash, .dash],
                          color: 0x188A48,
                          tone: .A6)
    public static let P = MorseLetter("P",
                          code: [.dot, .dash, .dash, .dot],
                          color: 0xF45F0D,
                          tone: .B6)
    public static let Q = MorseLetter("Q",
                          code: [.dash, .dash, .dot, .dash],
                          color: 0x01505E,
                          tone: .C6)
    public static let R = MorseLetter("R",
                          code: [.dot, .dash, .dot],
                          color: 0xC33BC3,
                          tone: .D6)
    public static let S = MorseLetter("S",
                          code: [.dot, .dot, .dot],
                          color: 0xDB1315,
                          tone: .E6)
    public static let T = MorseLetter("T",
                          code: [.dash],
                          color: 0x03017C,
                          tone: .G6)
    public static let U = MorseLetter("U",
                          code: [.dot, .dot, .dash],
                          color: 0x26681F,
                          tone: .A7)
    public static let V = MorseLetter("V",
                          code: [.dot, .dot, .dot, .dash],
                          color: 0xF1840F,
                          tone: .B7)
    public static let W = MorseLetter("W",
                          code: [.dot, .dash, .dash],
                          color: 0xEC64CD,
                          tone: .C7)
    public static let X = MorseLetter("X",
                          code: [.dash, .dot, .dot, .dash],
                          color: 0xA0430A,
                          tone: .D7)
    public static let Y = MorseLetter("Y",
                          code: [.dash, .dot, .dash, .dash],
                          color: 0x6B1EB2,
                          tone: .E7)
    public static let Z = MorseLetter("Z",
                          code: [.dash, .dash, .dot, .dot],
                          color: 0xEA1517,
                          tone: .F7)
    
    
    public static var array: Array<MorseLetter> = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z]
    
    public static var dictionary: Dictionary<Character, MorseLetter> = array.toDictionary {$0.char}
    
    public static var dictionaryWithSpace: Dictionary<Character, MorseLetter> = {
        var d =  array.toDictionary {$0.char}
        d[" "] =  MorseLetter(" ", code: [])
        return d
    }()
    
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        self.forEach { element in
            dict[selectKey(element)] = element
        }
        return dict
    }
}


