//
//  TimeInterval+Extension.swift
//  RequesterDemo
//
//  Created by ILYA SHKOLNIK on 05.12.2019.
//  Copyright © 2019 Ilya Shkolnik. All rights reserved.
//

import Foundation

/// TimeInterval extension
extension TimeInterval {
    /// Uptime
    static func uptime() -> TimeInterval? {
        var bootTime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var bootTimeSize = MemoryLayout<timeval>.size
        var now = time_t()
        var uptime: time_t = -1
        time(&now)
        if (sysctl(&mib, 2, &bootTime, &bootTimeSize, nil, 0) != -1 && bootTime.tv_sec != 0) {
            uptime = now - bootTime.tv_sec
        }
        return TimeInterval(Int(uptime))
    }
    
    /// Current time interval
    static func currentTimeInterval() -> TimeInterval {
        return TimeInterval.uptime() ?? Date().timeIntervalSince1970
    }
}
