//
//  RequesterProgress.swift
//  RequesterDemo
//
//  Created by ILYA SHKOLNIK on 05.12.2019.
//  Copyright © Darkness Production. All rights reserved.
//

import Foundation

/// Requester progress
public final class RequesterProgress: NSObject {
    /// Total bytes
    public var totalBytes: Int64
    
    /// Completed bytes
    public var completedBytes: Int64 = 0 {
        didSet {
            if isFinished {
                finishTimeInterval = TimeInterval.currentTimeInterval()
            }
        }
    }
    
    /// Duration
    public var duration: TimeInterval {
        return (finishTimeInterval ?? TimeInterval.currentTimeInterval()) - startTimeInterval
    }
    
    /// Fraction completed
    public var fractionCompleted: Double {
        guard totalBytes > 0 else { return 0.0 }
        return min(Double(completedBytes) / Double(totalBytes), 1.0)
    }
    
    /// Is finished
    public var isFinished: Bool {
        return fractionCompleted == 1.0
    }
    
    /// Estimated time remaining
    public var estimatedTimeRemaining: TimeInterval {
        return duration * ((1.0 - fractionCompleted) / fractionCompleted)
    }
    
    private var startTimeInterval: TimeInterval
    
    private var finishTimeInterval: TimeInterval?
    
    init(totalBytes: Int64) {
        self.totalBytes = totalBytes
        self.startTimeInterval = TimeInterval.currentTimeInterval()
    }
}
