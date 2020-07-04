//
//  Lib.swift
//  Pods
//
//  Created by Stephen Spalding on 6/20/16.
//
//

import Foundation

/// Applies function `f` to Int64 `i` atomically
func swap (_ i: inout Int64, f: (Int64) -> Int64) -> Int64 {
    while true {
        let p = i
        if OSAtomicCompareAndSwap64Barrier(p, f(p), &i) {
            return f(p)
        }
    }
}

/// Convert from NSDate instance to integer nanoseconds
func toNanos (_ t: NSDate) -> Int64 {
    return Int64(t.timeIntervalSince1970 * 1e9)
}

/// Convert from integer nanoseconds to NSDate instance
func fromNanos (_ t: Int64) -> NSDate {
    return NSDate.init(timeIntervalSince1970: Double(t) / 1e9)
}

/// Take ceiling to 48th bit
func ceil48 (_ t: Int64 ) -> Int64 {
    return t & ~0xffff | 0x10000
}
