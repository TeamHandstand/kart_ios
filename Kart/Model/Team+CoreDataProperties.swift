//
//  Team+CoreDataProperties.swift
//  Kart
//
//  Created by Sam Goldstein on 2/1/17.
//  Copyright © 2017 Sam Goldstein. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team");
    }

    @NSManaged public var goldCount: Int64
    @NSManaged public var silverCount: Int64
    @NSManaged public var bronzeCount: Int64
    @NSManaged public var ribbonCount: Int64
    @NSManaged public var ranking: Int64
    @NSManaged public var users: NSSet?
    @NSManaged public var tickets: NSSet?

}

// MARK: Generated accessors for users
extension Team {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

// MARK: Generated accessors for tickets
extension Team {

    @objc(addTicketsObject:)
    @NSManaged public func addToTickets(_ value: Ticket)

    @objc(removeTicketsObject:)
    @NSManaged public func removeFromTickets(_ value: Ticket)

    @objc(addTickets:)
    @NSManaged public func addToTickets(_ values: NSSet)

    @objc(removeTickets:)
    @NSManaged public func removeFromTickets(_ values: NSSet)

}
