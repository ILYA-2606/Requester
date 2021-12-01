//
//  URLSessionDataTask+Extension.swift
//  RequesterDemo
//
//  Created by Ilya Shkolnik on 05.12.2019.
//  Copyright © Darkness Production. All rights reserved.
//

import Foundation

/// URLSessionDataTask extension
extension URLSessionDataTask {
    private struct AssociatedKeys {
        static var requesterRequest = "URLSessionDataTask.requesterRequest"
        static var requesterResponse = "URLSessionDataTask.requesterResponse"
    }

    /// Request
    var requesterRequest: Request? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.requesterRequest) as? Request
        }
        set(object) {
            objc_setAssociatedObject(self, &AssociatedKeys.requesterRequest, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Response
    var requesterResponse: Response? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.requesterResponse) as? Response
        }
        set(object) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.requesterResponse,
                object,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
