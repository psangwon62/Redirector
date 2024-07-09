//
//  CoreDataManager.swift
//  Redirector
//
//  Created by 박상원 on 7/8/24.
//

import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Redirector")
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
      }
    }
    return container
  }()

  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  func fetchAppInfos() -> [AppInfo] {
    let request: NSFetchRequest<AppInfo> = AppInfo.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \AppInfo.index, ascending: true)]
    var result: [AppInfo] = []

    viewContext.performAndWait {
      do {
        result = try viewContext.fetch(request)
      } catch {
        print("Error fetching app infos \(error)")
      }
    }

    return result
  }

  func saveContext() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch {
        print("Error saving context: \(error)")
      }
    }
  }
}
