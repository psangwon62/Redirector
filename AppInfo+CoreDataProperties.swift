//
//  AppInfo+CoreDataProperties.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//
//

import CoreData
import Foundation

public extension AppInfo {
  @nonobjc class func fetchRequest() -> NSFetchRequest<AppInfo> {
    return NSFetchRequest<AppInfo>(entityName: "AppInfo")
  }

  @NSManaged var id: UUID?
  @NSManaged var logo: Data?
  @NSManaged var name: String?
  @NSManaged var index: Int16
  @NSManaged var descriptions: AppDescription?
}

extension AppInfo: Identifiable {}
