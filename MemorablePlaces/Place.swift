//
//  Place.swift (Places model)
//  MemorablePlaces
//
//  Created by Gaurav Konchady on 4/2/15.
//  Copyright (c) 2015 Gaurav Konchady. All rights reserved.
//

import Foundation
import CoreData

@objc(Place)
class Place: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var latitude: String
    @NSManaged var longitude: String

}
