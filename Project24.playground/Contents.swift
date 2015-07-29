//: Playground - noun: a place where people can play

import UIKit

var myInt = 0

extension Int {
    mutating func plusOne() {
        ++self
    }
    
    static func random(minimum min: Int, maximum max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}

myInt.plusOne()
myInt.plusOne()
myInt.plusOne()
myInt.plusOne()

Int.random(minimum: 11, maximum: 23)
