//
//  ViewController.swift
//  RequesterDemo
//
//  Created by Ilya Shkolnik on 05.12.2019.
//  Copyright © Darkness Production. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var percentLabel: UILabel!
    
    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoto()
    }
    
    func getPhoto() {
        imageView.image = nil
        percentLabel.text = "Starting..."
        networkService.obtainPhoto(
            completion: { [weak self] image in
                self?.imageView.image = image
        },
            failure: { [weak self] error in
                print("Photo download error: \(error?.localizedDescription ?? "?")")
                self?.imageView.image = nil
        },
            progressHandler: { [weak self] progress in
                self?.percentLabel.text = String(
                    format: "Progress: %.0f%%, Left seconds: %.0f",
                    progress.fractionCompleted * 100,
                    progress.estimatedTimeRemaining
                )
        })
    }

    @IBAction func retryTouched() {
        getPhoto()
    }
    
}

