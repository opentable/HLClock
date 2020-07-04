//
//  NetworkTime.swift
//  Pods
//
//  Created by Stephen Spalding on 6/20/16.
//
//

import Foundation

public class NetworkTime {
    // Create global instance
    public static let global = NetworkTime()
    
    /// Physical Time offset in nanoseconds
    var offsetNanos : Int64 = 0
    
    /// Physical Time
    public func now() -> Int64 {
        return ceil48(toNanos(NSDate()) + self.offsetNanos)
    }
    
    /// Update clock offset
    public func updateOffset(referenceTime: NSDate) -> Int64 {
        let myTime = NSDate()
        let delta = referenceTime.timeIntervalSince1970 - myTime.timeIntervalSince1970
        let newOffset : Int64 = abs(delta) >= 1 ? Int64(delta * 1e9) : 0
        return swap(&self.offsetNanos,
                    f: {current in abs(newOffset - current) >= Int64(1e9) ? newOffset : current})
    }
}
