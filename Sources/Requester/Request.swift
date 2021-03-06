//
//  Request.swift
//  RequesterDemo
//
//  Created by Ilya Shkolnik on 05.12.2019.
//  Copyright © Darkness Production. All rights reserved.
//

import Foundation

/// Request
public final class Request {
    /// HTTP-method
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case head = "HEAD"
        case put = "PUT"
        case delete = "DELETE"
        case link = "LINK"
        case unlink = "UNLINK"
        case patch = "PATCH"
        case trace = "TRACE"
        case options = "OPTIONS"
        case connect = "CONNECT"
    }

    /// URL
    public var url: URL

    /// HTTP-method
    public var method: Method

    /// Body
    public var body: Any?

    /// Headers
    public var headers: [String: String]?

    /// Timeout
    public var timeout: TimeInterval = 60.0

    /// Cache policy
    public var cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy

    /**
     Request initializer
     - parameter url: URL
     - parameter method: HTTP-method
     - parameter body: Body
     - parameter headers: Headers     
     - parameter timeout: Timeout interval
     - parameter cachePolicy: Cache policy
     */
    public init(
        url: URL,
        method: Method = .get,
        body: Any? = nil,
        headers: [String: String]? = nil,
        timeout: TimeInterval = 60,
        cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
        self.timeout = timeout
        self.cachePolicy = cachePolicy
    }

    /**
     Request initializer with URLRequest
     - parameter urlRequest: URLRequest
     */
    public init?(urlRequest: URLRequest) {
        guard
            let url = urlRequest.url,
            let httpMethod = urlRequest.httpMethod,
            let method = Method(rawValue: httpMethod)
        else { return nil }
        self.url = url
        self.method = method
        timeout = urlRequest.timeoutInterval
        body = urlRequest.httpBody
        headers = urlRequest.allHTTPHeaderFields
        cachePolicy = urlRequest.cachePolicy
    }
}
