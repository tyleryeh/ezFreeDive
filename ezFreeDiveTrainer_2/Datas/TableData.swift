//
//  TableData.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/27.
//

import Foundation
import CoreData
import UIKit

class TableData: NSManagedObject {
    
    @NSManaged var tableID: String
    @NSManaged var tableName: String?
    @NSManaged var hold: String?
    @NSManaged var breath: String?
    
    @NSManaged var set: String?
    @NSManaged var reduce: String?
    @NSManaged var saveDate: String?
    @NSManaged var whitchTable: String?
    
    
    override func awakeFromInsert() {
        self.tableID = UUID().uuidString
    }
    
    
}
