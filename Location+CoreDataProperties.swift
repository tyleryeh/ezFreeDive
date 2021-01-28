//
//  Location+CoreDataProperties.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/28.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var lon: String?
    @NSManaged public var lat: String?
    @NSManaged public var toDiary: Diary?

}

extension Location : Identifiable {

}
