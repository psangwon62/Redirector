//
//  AppSettingsViewModel.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import Foundation
import SwiftUI

class AppSettingViewModelDeprecated: ObservableObject {
//  @Published var list = [Apps(name: "App Store", image: NSImage(resource: .appStore))]
  @Published var list = ["A", "B"]
  @Published var appInfos = [AppInfo]()
  @Published var selectedIndex: Int = 0
  let manager = AppInfoManager.shared
  
  init(list: [String] = ["A", "B"], appInfos: [AppInfo] = [AppInfo](), selectedIndex: Int = 0) {
    self.list = list
    self.appInfos = manager.getAllApps()
    self.selectedIndex = selectedIndex
    print("viewmodel init")
  }
  
  var listCount: Int {
    list.count
  }

  var appInfosCount: Int {
    appInfos.count
  }
  
  var addButtonDisabled: Bool {
    list.count >= 4
  }

  var removeButtonDisabled: Bool {
    list.count <= 1
  }

//  var appDescription: String {
//    get { list[selectedIndex].appDescription.description ?? "" }
//    set { list[selectedIndex].appDescription.description = newValue }
//  }
//
//  var appTitle: String {
//    get { list[selectedIndex].appDescription.title ?? "" }
//    set { list[selectedIndex].appDescription.title = newValue }
//  }

//  func appName(_ index: Int) -> String {
//    list[index].name
//  }
//
//  func appImage(_ index: Int) -> NSImage? {
//    list[index].image
//  }
//
  func updateSelectedIndex(_ index: Int) {
    selectedIndex = index
  }

//  func removeApp() {
//    list.remove(at: selectedIndex)
//    selectedIndex = min(list.count - 1, selectedIndex)
//  }

  func removeApp() {
    manager.deleteItems(offsets: IndexSet([selectedIndex]))
    selectedIndex = min(list.count - 1, selectedIndex)
  }
//
//  func addApp() {
//    guard let panel = openPanel(type: [.application]) else { return }
//    if panel.runModal() == .OK {
//      guard let url = panel.urls.first else { return }
//      if let appName = url.pathComponents.last {
//        let name = appName.components(separatedBy: ".")[0]
//        if list.contains(where: { $0.name == name }) {
//          // alert for existing app
//        } else {
//          list.append(Apps(name: name, image: getIcon(application: appName) ?? NSImage(resource: .figma)))
//          selectedIndex = list.count - 1
//        }
//      }
//    }
//  }
//

  func addApp() {
    guard let panel = openPanel(type: [.application]) else { return }
    if panel.runModal() == .OK {
      guard let url = panel.urls.first else { return }
      if let appName = url.pathComponents.last {
        let name = appName.components(separatedBy: ".")[0]
        if appInfos.contains(where: { $0.name == name }) {
          // alert for existing app
        } else {
          manager.addAppInfo(name: name)
          selectedIndex = list.count - 1
        }
      }
    }
  }

  func getIcon(file path: String) -> NSImage? {
    guard FileManager.default.fileExists(atPath: path)
    else { return nil }

    return NSWorkspace.shared.icon(forFile: path)
  }

  func getIcon(bundleID: String) -> NSImage? {
    guard let path = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: bundleID)
    else { return nil }

    return getIcon(file: path)
  }

  func getIcon(application: String) -> NSImage? {
    guard let path = NSWorkspace.shared.fullPath(forApplication: application)
    else { return nil }

    return getIcon(file: path)
  }

  func onMoveUsers(fromOffsets source: IndexSet, toOffset destination: Int) {
    list.move(fromOffsets: source, toOffset: destination)
  }
}
