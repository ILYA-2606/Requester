// DispatchQueue+Extension.swift
// Copyright © 2019 PJSC Bank Otkritie. All rights reserved.

import Foundation

/// Удобная работа с background/main блоками кода
extension DispatchQueue {
    public class func main(delay: TimeInterval = 0, main: @escaping () -> ()) {
        guard delay > 0 else {
            DispatchQueue.main.async { main() }
            return
        }
        let milliseconds = Int(delay * 1000.0)
        let time: DispatchTime = .now() + DispatchTimeInterval.milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: time, execute: main)
    }

    public class func background(priority: DispatchQoS.QoSClass = .default, background: @escaping () -> ()) {
        DispatchQueue.global(qos: priority).async { background() }
    }

    public class func backgroundAndMain(
        priority: DispatchQoS.QoSClass = .default,
        background: @escaping () -> (),
        main: @escaping () -> ()
    ) {
        DispatchQueue.global(qos: priority).async {
            background()
            DispatchQueue.main.async { main() }
        }
    }
}
