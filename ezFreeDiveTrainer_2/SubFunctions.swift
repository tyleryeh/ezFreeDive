//
//  SubFunctions.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/29.
//

import Foundation
import UIKit

class SubFunctions {
    
    static let shared = SubFunctions()
    
    private init() {
        
    }
    
    func intToStringForTimeFormatter(input: Int) -> String{
        let min = input / 60 % 60
        let sec = input % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
}
