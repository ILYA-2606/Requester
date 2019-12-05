//
//  NetworkService.swift
//  RequesterDemo
//
//  Created by Ilya Shkolnik on 05.12.2019.
//  Copyright © 2019 Ilya Shkolnik. All rights reserved.
//

import UIKit

final class NetworkService {
    typealias DoubleHandler = (Double) -> ()
    typealias ImageHandler = (UIImage) -> ()
    typealias ErrorHandler = (Error?) -> ()
    
    let requester = Requester.shared
    var obtainPhotoTask: URLSessionDataTask?
    
    func obtainPhoto(
        completion: @escaping ImageHandler,
        failure: @escaping ErrorHandler,
        progressHandler: @escaping DoubleHandler
    ) {
        guard let url = URL(string: "https://content.fortune.com/wp-content/uploads/2015/09/stevefinal-1.jpg") else {
            return
        }
        obtainPhotoTask?.cancel()
        obtainPhotoTask = requester.sendDataRequest(
            url: url,
            completion: completion,
            failure: failure,
            progressHandler: { progress in
                let percent = progress.fractionCompleted
                progressHandler(percent)
        })
    }
    
}
