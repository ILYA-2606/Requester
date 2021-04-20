// Requester.swift
// Copyright © 2019 PJSC Bank Otkritie. All rights reserved.

import UIKit

/// Request Manager
public final class Requester: NSObject {
    // MARK: - Types
    
    public typealias ResultHandler = (_ result: Any?, _ error: Error?) -> Void
    public typealias ProgressHandler = (_ progress: RequesterProgress) -> Void
    
    // MARK: - Properties

    public static let shared = Requester()

    /// Active session tasks
    public var tasks = [URLSessionDataTask]()

    /// Client certificate with private key
    public var identity: SecIdentity?

    /// Server certificates
    public var certificates: [Any]?
    
    /// Allow trust to server
    public var isAllowTrustServer = false

    // MARK: - Private Properties

    private var session: URLSession!
    private var taskLock = NSLock()

    // MARK: - Public Methods

    /**
     Send request with data response
     - parameter url: Request URL
     - parameter method: HTTP-method
     - parameter body: Request body
     - parameter headers: Request headers
     - parameter timeout: Request timeout interval
     - parameter cachePolicy: Request cache policy
     - parameter completion: Completion block
     - parameter failure: Failure block
     - parameter progressHandler: Progress block
     */
    @discardableResult
    public func sendDataRequest<ResultType: Any>(
        url: URL,
        method: Request.Method = .get,
        body: Any? = nil,
        headers: [String: String]? = nil,
        timeout: TimeInterval = 60,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        completion: @escaping ((ResultType) -> ()),
        failure: @escaping ((Error?) -> ()),
        progressHandler: ProgressHandler? = nil
    ) -> URLSessionDataTask {
        return sendRequest(
            url: url,
            method: method,
            body: body,
            headers: headers,
            timeout: timeout,
            cachePolicy: cachePolicy,
            completion: { result, error in
                if let error = error {
                    failure(error)
                    return
                }
                var response: (ResultType?, Error?)
                DispatchQueue.backgroundAndMain(
                    background: {
                        if ResultType.self is String.Type {
                            guard let data = result as? Data else {
                                response = (nil, error)
                                return
                            }
                            let string = String(data: data, encoding: .utf8) as? ResultType
                            response = (string, error)
                        } else if ResultType.self is UIImage.Type {
                            guard let data = result as? Data else {
                                response = (nil, error)
                                return
                            }
                            let image = UIImage(data: data) as? ResultType
                            response = (image, error)
                        } else {
                            response = (result as? ResultType, error)
                        }
                },
                    main: {
                        guard let result = response.0 else {
                            failure(nil)
                            return
                        }
                        completion(result)
                })
        },
            progressHandler: progressHandler
        )
    }

    /**
     Send request with JSON parsed-object
     - parameter url: Request URL
     - parameter method: HTTP-method
     - parameter body: Request body
     - parameter headers: Request headers
     - parameter timeout: Request timeout interval
     - parameter cachePolicy: Request cache policy
     - parameter completion: Completion block
     - parameter failure: Failure block
     - parameter progressHandler: Progress block
     */
    @discardableResult
    public func sendJSONRequest<ResultType: Decodable>(
        url: URL,
        method: Request.Method = .get,
        body: Any? = nil,
        headers: [String: String]? = nil,
        timeout: TimeInterval = 60,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        completion: @escaping ((ResultType) -> ()),
        failure: @escaping ((Error?) -> ()),
        progressHandler: ProgressHandler? = nil
    ) -> URLSessionDataTask {
        return sendRequest(
            url: url,
            method: method,
            body: body,
            headers: headers,
            timeout: timeout,
            cachePolicy: cachePolicy,
            completion:  { result, error in
                guard
                    let data = result as? Data,
                    let result = try? JSONDecoder().decode(ResultType.self, from: data)
                else {
                    failure(error)
                    return
                }
                completion(result)
        },
            progressHandler: progressHandler
        )
    }

    /**
     Send request with parsed-object
     - parameter url: Request URL
     - parameter method: HTTP-method
     - parameter body: Request body
     - parameter headers: Request headers
     - parameter timeout: Request timeout interval
     - parameter cachePolicy: Request cache policy
     - parameter completion: Completion block
     - parameter progressHandler: Progress block
     */
    @discardableResult
    public func sendRequest(
        url: URL,
        method: Request.Method = .get,
        body: Any? = nil,
        headers: [String: String]? = nil,
        timeout: TimeInterval = 60,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        completion: @escaping ResultHandler,
        progressHandler: ProgressHandler? = nil
    ) -> URLSessionDataTask {
        let request = Request(
            url: url,
            method: method,
            body: body,
            headers: headers,
            timeout: timeout,
            cachePolicy: cachePolicy
        )
        let response = Response(resultHandler: completion, progressHandler: progressHandler)
        return sendRequest(request, response: response)
    }

    // MARK: - Private Methods

    private override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        if #available(iOS 13.0, *) {
            configuration.tlsMinimumSupportedProtocolVersion = .TLSv12
        } else {
            configuration.tlsMinimumSupportedProtocol = .tlsProtocol12
        }
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    private func sendRequest(_ request: Request, response: Response) -> URLSessionDataTask {
        var urlRequest = URLRequest(
            url: request.url,
            cachePolicy: request.cachePolicy,
            timeoutInterval: request.timeout
        )
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = bodyData(object: request.body)
        if let headers = request.headers {
            let headersDictionary = headers as NSDictionary
            for key in headersDictionary.allKeys {
                guard
                    let keyString = key as? String,
                    let valueString = headersDictionary[key] as? String
                else { continue }
                urlRequest.setValue(valueString, forHTTPHeaderField: keyString)
            }
        }
        let task = session.dataTask(with: urlRequest)
        task.requesterRequest = request
        task.requesterResponse = response
        task.resume()
        taskLock.lock()
        tasks.append(task)
        taskLock.unlock()
        return task
    }

    private func bodyData(object: Any?) -> Data? {
        guard let object = object else { return nil }
        if let data = object as? Data {
            return data
        } else if let string = object as? String {
            return string.data(using: .utf8)
        }
        return nil
    }

    private func removeTask(_ task: URLSessionTask) {
        taskLock.lock()
        for (index, currentTask) in tasks.enumerated() where task.taskIdentifier == currentTask.taskIdentifier {
            tasks.remove(at: index)
            break
        }
        taskLock.unlock()
    }
}

// MARK: - URLSessionDelegate

extension Requester: URLSessionDelegate {
    public func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        if challenge.previousFailureCount == 0 {
            guard let identity = identity else {
                if isAllowTrustServer, let trust = challenge.protectionSpace.serverTrust {
                    completionHandler(
                        Foundation.URLSession.AuthChallengeDisposition.useCredential,
                        URLCredential(trust: trust)
                    )
                    return
                }
                completionHandler(.performDefaultHandling, nil)
                return
            }
            let credential = URLCredential(identity: identity, certificates: certificates, persistence: .permanent)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

// MARK: - URLSessionDataDelegate

extension Requester: URLSessionDataDelegate {
    public func urlSession(
        _: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        guard let taskResponse = dataTask.requesterResponse else { return }
        taskResponse.responseData = Data()
        taskResponse.requesterProgress = RequesterProgress(totalBytes: response.expectedContentLength)
        DispatchQueue.main {
            taskResponse.progressHandler?(taskResponse.requesterProgress)
        }
        completionHandler(.allow)
    }

    public func urlSession(
        _: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        guard let response = dataTask.requesterResponse else { return }
        response.responseData.append(data)
        response.requesterProgress.completedBytes = Int64(response.responseData.count)
        DispatchQueue.main {
            response.progressHandler?(response.requesterProgress)
        }
    }

    public func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer { removeTask(task) }
        guard
            let dataTask = task as? URLSessionDataTask,
            let response = dataTask.requesterResponse
        else { return }
        if let error = error {
            DispatchQueue.main {
                response.resultHandler(nil, error)
            }
            return
        }
        DispatchQueue.main {
            response.progressHandler?(response.requesterProgress)
            response.resultHandler(response.responseData, nil)
        }
    }
}
