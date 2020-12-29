//
//  NotificationName.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/29.
//

import Foundation

extension Notification.Name {
    static let finishProgress = Notification.Name(rawValue: "finishProgress")
    static let pauseProgress = Notification.Name(rawValue: "pauseProgress")
    static let continueProgress = Notification.Name(rawValue: "continueProgress")
}
