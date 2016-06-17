//
//  HLClock.swift
//  Pods
//
//  Hybrid Logical Clock
//
//  Implements the HLC send and receive funcions as described in the
//  paper: http://www.cse.buffalo.edu/tech-reports/2014-04.pdf
//  blog post: http://muratbuffalo.blogspot.com/2014/07/hybrid-logical-clocks.html
//
//  Created by Stephen Spalding on 6/14/16.
//
//

import Foundation
import UIKit

/// Send function as described in Figure 5 of HLC paper
func hlc_send<L:IntegerType, C:IntegerType> (j: (l:L, c:C), pt:L) -> (L, C) {
    var j´ = j
    
    j´.l = max(j.l, pt)
    
    if j´.l == j.l {
        j´.c = j.c + 1
    } else {
        j´.c = 0
    }
    
    return j´
}

/// Receive function as described in Figure 5 of HLC paper
func hlc_recv<L:IntegerType, C:IntegerType> (j: (l:L, c:C), m: (l:L, c:C), pt:L) -> (L, C) {
    var j´ = j
    
    j´.l = max(j.l, m.l, pt)
    
    if j´.l == j.l && j´.l == m.l {
        j´.c = max(j.c, m.c) + 1
    } else if j´.l == j.l {
        j´.c = j.c + 1
    } else if j.l == m.l {
        j´.c = m.c + 1
    } else {
        j´.c = 0
    }
    
    return j´
}



/// Take ceiling to 48th bit
func ceil48 ( t: Int64 ) -> Int64 {
    return t & ~0xffff | 0x10000
}

/// Pack l and c into 64bit timestamp
/// See HLC paper: '6.2 Compact Timestamping using l and c'
func hlc_pack( t: (l:Int64, c:Int64) ) -> Int64 {
    return ceil48(t.l) | t.c
}

func hlc_unpack( t: Int64 ) -> (l: Int64, c: Int64) {
    return (t & ~0xffff, t & 0xffff)
}

/// Current time in nanoseconds since epoch
func now() -> Int64 {
    return Int64(NSDate().timeIntervalSince1970 * 1e9)
}

/// Applies function `f` to Int64 `i` atomically
func swap (inout i: Int64, f: Int64 -> Int64) -> Int64 {
    while true {
        let p = i
        if OSAtomicCompareAndSwap64Barrier(p, f(p), &i) {
            return f(p)
        }
    }
}

func toNanos (t: NSDate) -> Int64 {
    return Int64(t.timeIntervalSince1970 * 1e9)
}

func fromNanos (t: Int64) -> NSDate {
    return NSDate.init(timeIntervalSince1970: Double(t) / 1e9)
}

public class HLClock {
    // Create global instance
    static let global = HLClock()
    
    /// Clock state
    private var j : Int64 = 0
    
    /// Physical Time offset in nanoseconds
    var offsetNanos : Int64 = 0
    
    /// Physical Time
    static func pt() -> Int64 {
        return ceil48(toNanos(NSDate()) + global.offsetNanos)
    }
    
    // Wrap hlc_send and hlc_recv, unpacking inputs and packing outputs
    public static func send() -> Int64 {
        return swap(&global.j, f: {j in hlc_pack(hlc_send(hlc_unpack(j), pt: pt()))})
    }
    
    public static func recv(m:Int64) -> Int64 {
        return swap(&global.j,
            f: {j in hlc_pack(hlc_recv(hlc_unpack(j), m: hlc_unpack(m), pt: pt()))})
    }
    
    /// Update clock offset
    public static func updateOffset(referenceTime: NSDate) -> Int64 {
        let myTime = NSDate()
        let delta = referenceTime.timeIntervalSince1970 - myTime.timeIntervalSince1970
        let newOffset : Int64 = abs(delta) >= 1 ? Int64(delta * 1e9) : 0
        return swap(&global.offsetNanos,
            f: {current in abs(newOffset - current) >= Int64(1e9) ? newOffset : current})
    }
}