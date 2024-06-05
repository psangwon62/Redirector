//
//  AppInfoManager.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//

import CoreData
import Foundation
import SwiftUI

class AppInfoManager {
  static let shared = AppInfoManager()

  let context = PersistenceController.shared.container.viewContext

  func getAllApps() -> [AppInfo] {
    let request: NSFetchRequest<AppInfo> = AppInfo.fetchRequest()
    do {
      return try context.fetch(request).sorted(by: { $0.index > $1.index })
    } catch {
      print("Couldn't fetch all apps: \(error.localizedDescription)")
      return []
    }
  }

  func addAppInfo() throws -> AppInfo {
    let newAppInfo = AppInfo(context: context)
    newAppInfo.name = "newItem" + String(getAllApps().count)
    newAppInfo.index = Int16(getAllApps().count - 1)
    newAppInfo.id = UUID()
    try saveContext()

    return newAppInfo
  }

  func deleteItems(offsets: IndexSet) throws {
    offsets.map { getAllApps()[$0] }.forEach(context.delete)

    try saveContext()
  }

  func saveContext() throws {
    do {
      if context.hasChanges {
        try context.save()
      }
    } catch {
      print("Couldn't save Coredata context: \(error.localizedDescription)")
    }
  }
}
