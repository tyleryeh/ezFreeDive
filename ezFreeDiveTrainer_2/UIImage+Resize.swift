//
//  UIImage+Resize.swift
//  HelloTakePhoto
//
//  Created by Kent Liu on 2020/4/30.
//  Copyright © 2020 iPAS. All rights reserved.
//

import UIKit

extension UIImage {
  
  func resize(newSize: CGSize) -> UIImage? {
    
    UIGraphicsBeginImageContext(newSize)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    self.draw(in: rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext() // Important!!!!!
    
    return result
  }
  
}

