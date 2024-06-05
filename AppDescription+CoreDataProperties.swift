//
//  AppDescription+CoreDataProperties.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//
//

import CoreData
import Foundation

public extension AppDescription {
  @nonobjc class func fetchRequest() -> NSFetchRequest<AppDescription> {
    return NSFetchRequest<AppDescription>(entityName: "AppDescription")
  }

  @NSManaged var intro: String?
  @NSManaged var subTitle: String?
  @NSManaged var title: String?
  @NSManaged var app: AppInfo?
}

extension AppDescription: Identifiable {}
