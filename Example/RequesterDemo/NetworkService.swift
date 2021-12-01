//
//  NetworkService.swift
//  RequesterDemo
//
//  Created by Ilya Shkolnik on 05.12.2019.
//  Copyright © Darkness Production. All rights reserved.
//

import Requester
import UIKit

final class NetworkService {
    typealias ProgressHandler = (RequesterProgress) -> ()
    typealias ImageHandler = (UIImage) -> ()
    typealias ErrorHandler = (Error?) -> ()
    
    let requester = Requester.shared
    var obtainPhotoTask: URLSessionDataTask?
    
    func obtainPhoto(
        completion: @escaping ImageHandler,
        failure: @escaping ErrorHandler,
        progressHandler: @escaping ProgressHandler
    ) {
        guard let url = URL(string: "https://content.fortune.com/wp-content/uploads/2015/09/stevefinal-1.jpg") else {
            return
        }
        obtainPhotoTask?.cancel()
        obtainPhotoTask = requester.sendDataRequest(
            url: url,
            completion: completion,
            failure: failure,
            progressHandler: progressHandler)
    }
    
}
