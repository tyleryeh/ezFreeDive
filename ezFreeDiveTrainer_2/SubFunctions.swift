//
//  SubFunctions.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/29.
//

import Foundation
import UIKit
import CoreData

class SubFunctions {
    
    static let shared = SubFunctions()
    
    private init() {
        
    }
    
    //Core Data Part
    
    //Fetch Data
    //TableData
    private let moc = CoreDataHelper.shared.managedObjectContext()
    func fetchTableData() -> [TableData] {
        var data = [TableData]()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "whitchTable contains[cd] %@", "RT")
        let order = NSSortDescriptor(key: "saveDate", ascending: true)
        fetchRequest.sortDescriptors = [order]
        moc.performAndWait {
            do {
                data = try moc.fetch(fetchRequest)
            } catch {
                data = []
            }
        }
        return data
    }
    //DiaryData
    func fetchDiaryData() -> [Diary]? {
        var data: [Diary]?
        moc.performAndWait {
            do {
                data = try moc.fetch(Diary.fetchRequest())
            } catch {
                data = []
            }
        }
        return data
    }
    
    func intToStringForTimeFormatter(input: Int) -> String{
        let min = input / 60 % 60
        let sec = input % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
    //畫漸層
    func drawGradual(image: UIImageView, arcCenterMustBeSquareViewXY XY: CGFloat, radius r: CGFloat, color1 c1: String, color2 c2: String) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: image.frame.size)
        let color1 = UIColor(hexString: c1).cgColor
        let color2 = UIColor(hexString: c2).cgColor
        gradient.colors = [color1, color2]
        let shape = CAShapeLayer()
        shape.lineWidth = 4
        shape.path = UIBezierPath(arcCenter: CGPoint(x: XY, y: XY), radius: r, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        image.layer.addSublayer(gradient)
    }
    
}
