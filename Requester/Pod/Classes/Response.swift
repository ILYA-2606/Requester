//
//  Response.swift
//  RequesterDemo
//
//  Created by Ilya Shkolnik on 05.12.2019.
//  Copyright © 2019 Ilya Shkolnik. All rights reserved.
//

import UIKit

/// Response
final class Response {
    /// Result block
    var resultHandler: Requester.ResultHandler

    /// Progress block [0; 1]
    var progressHandler: Requester.ProgressHandler?

    /// Response data
    var responseData = Data()
    
    /// Progress
    var requesterProgress = RequesterProgress(totalBytes: 0)

    /**
     Response initializer
     - parameter resultHandler: Result block
     - parameter progressHandler: Progress block
     */
    init(resultHandler: @escaping Requester.ResultHandler, progressHandler: Requester.ProgressHandler?) {
        self.resultHandler = resultHandler
        self.progressHandler = progressHandler
    }
}
