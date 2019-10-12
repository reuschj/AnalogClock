//
//  Ratio.swift
//  AnalogClock
//
//  Created by Justin Reusch on 4/5/19.
//  Copyright © 2019 Justin Reusch. All rights reserved.
//

import Foundation

func findGCD<T>(ofIntegers a: T, and b: T) -> T where T: SignedInteger {
    let remainder: T = a % b
    if remainder != 0 {
        return findGCD(ofIntegers: abs(b), and: remainder)
    } else {
        return abs(b)
    }
}

func findGCD<T>(ofFloatingPoints a: T, and b: T) -> T where T: FloatingPoint {
    let remainder: T = a.truncatingRemainder(dividingBy: b)
    if remainder != 0 {
        return findGCD(ofFloatingPoints: abs(b), and: remainder)
    } else {
        return abs(b)
    }
}

// Reduces the ratio of two numbers
func reduceRatio<T>(ofIntegers a: T, and b: T) -> (a: T, b: T) where T: SignedInteger {
    let gcd: T = findGCD(ofIntegers: a, and: b)
    return (a / gcd, b / gcd)
}

// Reduces the ratio of two numbers
func reduceRatio<T>(ofFloatingPoints a: T, and b: T) -> (a: T, b: T) where T: FloatingPoint {
    let gcd: T = findGCD(ofFloatingPoints: a, and: b)
    return (a / gcd, b / gcd)
}
