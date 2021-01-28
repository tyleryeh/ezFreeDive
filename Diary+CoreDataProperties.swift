//
//  Diary+CoreDataProperties.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/28.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var diaryId: String?
    @NSManaged public var diaryName: String?
    @NSManaged public var diaryTextView: String?
    @NSManaged public var moodName: String?
    @NSManaged public var placeName: String?
    @NSManaged public var placeTempMax: String?
    @NSManaged public var placeTempMin: String?
    @NSManaged public var placeWeatherName: String?
    @NSManaged public var eSuit: String?
    @NSManaged public var eMask: String?
    @NSManaged public var eFins: String?
    @NSManaged public var eWeight: String?
    @NSManaged public var eMaxDepth: String?
    @NSManaged public var eVisibility: String?
    @NSManaged public var eWaterTemp: String?
    @NSManaged public var eDiveTime: String?
    @NSManaged public var toLocation: NSSet?

}

// MARK: Generated accessors for toLocation
extension Diary {

    @objc(addToLocationObject:)
    @NSManaged public func addToToLocation(_ value: Location)

    @objc(removeToLocationObject:)
    @NSManaged public func removeFromToLocation(_ value: Location)

    @objc(addToLocation:)
    @NSManaged public func addToToLocation(_ values: NSSet)

    @objc(removeToLocation:)
    @NSManaged public func removeFromToLocation(_ values: NSSet)

}

extension Diary : Identifiable {

}
