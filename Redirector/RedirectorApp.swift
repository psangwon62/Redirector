//
//  RedirectorApp.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//

import SwiftUI

@main
struct RedirectorApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
