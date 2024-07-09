//
//  RedirectorApp.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//

import SwiftUI

@main
struct RedirectorApp: App {
  let persistenceContainer = CoreDataManager.shared.persistentContainer
  @StateObject private var viewModel = AppManageViewModel(appInfoService: AppInfoService.shared)

  var body: some Scene {
    WindowGroup {
//      TestView(viewModel: viewModel)
//      SettingsView()
//      ContentView()
      Text("ContentView")
        .environment(\.managedObjectContext, persistenceContainer.viewContext)
    }
    Settings {
      SettingsView(viewModel: viewModel)
    }
  }
}
