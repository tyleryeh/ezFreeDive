//
//  DiaryData.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/8.
//

import Foundation
import CoreData

class DiaryData: NSManagedObject {
    
    @NSManaged var diaryID: String
    @NSManaged var diaryName: String?
    @NSManaged var weatherLocation: String?
    @NSManaged var weather: String?
    @NSManaged var tempMin: String?
    @NSManaged var tempMax: String?
    @NSManaged var moodemoji: String?
    
    override func awakeFromInsert() {
        self.diaryID = UUID().uuidString
    }
    
    
}
