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
func send<L:FixedWidthInteger, C:FixedWidthInteger> (_ j: (l:L, c:C), pt:L) -> (L, C) {
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
func recv<L:FixedWidthInteger, C:FixedWidthInteger> (_ j: (l:L, c:C), m: (l:L, c:C), pt:L) -> (L, C) {
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


// Pack and Unpack, see HLC paper: '6.2 Compact Timestamping using l and c'

/// Pack l and c into 64bit timestamp
func pack(_ t: (l:Int64, c:Int64) ) -> Int64 {
    return ceil48(t.l) | t.c
}

/// Unack l and c from 64bit timestamp
func unpack(_ t: Int64 ) -> (l: Int64, c: Int64) {
    return (t & ~0xffff, t & 0xffff)
}


/// Hybrid Logical Clock.
public class HLClock {
    /// Create global instance
    public static let global = HLClock(clock: NetworkTime.global.now)
    
    /// Clock state
    var j : Int64 = 0
    
    /// Physical time generator
    var clock : ()->Int64
    
    public init (clock: @escaping ()->Int64 = NetworkTime.global.now) {
        self.clock = clock
    }
    
    /// Get current time as HLC timestamp
    public func now() -> Int64 {
        return swap(&self.j, f: {j in pack(send(unpack(j), pt: ceil48(self.clock())))})
    }
    
    /// Update internal state with received message
    public func update(m:Int64) -> Int64 {
        return swap(&self.j,
                    f: {j in pack(recv(unpack(j), m: unpack(m), pt: ceil48(self.clock())))})
    }
}
