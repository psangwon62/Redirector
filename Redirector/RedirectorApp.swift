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
  @StateObject private var viewModel = TestViewModel(viewContext: PersistenceController.shared.container.viewContext)

  var body: some Scene {
    WindowGroup {
      TestView(viewModel: viewModel)
//      SettingsView()
//      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
    Settings {
      SettingsView()
    }
  }
}
