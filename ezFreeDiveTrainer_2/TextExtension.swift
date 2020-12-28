//
//  TextExtension.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/27.
//

import Foundation
import UIKit

extension Int {
    
    func string(for value: Int) -> String {
        let interval = value
        let minutes = interval / 60 % 60
        let seconds = interval % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
}
