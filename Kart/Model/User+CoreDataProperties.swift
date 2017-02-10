//
//  User+CoreDataProperties.swift
//  Kart
//
//  Created by Sam Goldstein on 2/1/17.
//  Copyright © 2017 Sam Goldstein. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var cell: String?
    @NSManaged public var email: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var pushEnabled: Bool
    @NSManaged public var facetimeCount: Int32
    @NSManaged public var totalAntiMiles: Float
    @NSManaged public var totalDistanceMiles: Float
    @NSManaged public var purchasedTickets: NSSet?
    @NSManaged public var ticket: Ticket?
    @NSManaged public var team: Team?

}

// MARK: Generated accessors for purchasedTickets
extension User {

    @objc(addPurchasedTicketsObject:)
    @NSManaged public func addToPurchasedTickets(_ value: Ticket)

    @objc(removePurchasedTicketsObject:)
    @NSManaged public func removeFromPurchasedTickets(_ value: Ticket)

    @objc(addPurchasedTickets:)
    @NSManaged public func addToPurchasedTickets(_ values: NSSet)

    @objc(removePurchasedTickets:)
    @NSManaged public func removeFromPurchasedTickets(_ values: NSSet)

}
