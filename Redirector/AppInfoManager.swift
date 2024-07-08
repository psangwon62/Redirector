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
//  @Environment(\.managedObjectContext) private var viewContext
  
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

  func addAppInfo(name: String)/* -> AppInfo*/ {
    let newAppInfo = AppInfo(context: context)
    newAppInfo.name = name
    newAppInfo.index = Int16(getAllApps().count - 1)
    newAppInfo.id = UUID()
    saveContext()
//
//    return newAppInfo
  }

  func deleteItems(offsets: IndexSet) {
    offsets.map { getAllApps()[$0] }.forEach(context.delete)

    saveContext()
  }

  func saveContext() {
    do {
//      if context.hasChanges {
        try context.save()
//      }
    } catch {
      print("Couldn't save Coredata context: \(error.localizedDescription)")
    }
  }
}
