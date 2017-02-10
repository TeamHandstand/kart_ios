//
//  Ticket+CoreDataProperties.swift
//  Kart
//
//  Created by Sam Goldstein on 2/1/17.
//  Copyright © 2017 Sam Goldstein. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Ticket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ticket> {
        return NSFetchRequest<Ticket>(entityName: "Ticket");
    }

    @NSManaged public var code: String?
    @NSManaged public var claimedAt: NSDate?
    @NSManaged public var forfeitedAt: NSDate?
    @NSManaged public var purchasedAt: NSDate?
    @NSManaged public var purchaser: User?
    @NSManaged public var player: User?
    @NSManaged public var team: Team?

}
