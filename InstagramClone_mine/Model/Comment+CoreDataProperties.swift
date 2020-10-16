//
//  Comment+CoreDataProperties.swift
//  InstagramClone_mine
//
//  Created by Steve on 15/10/2020.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var parentPost: Post?

}

extension Comment : Identifiable {

}
