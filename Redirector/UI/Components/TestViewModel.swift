//
//  TestViewModel.swift
//  Redirector
//
//  Created by 박상원 on 6/8/24.
//

import Cocoa
import CoreData
import SwiftUI

class TestViewModel: ObservableObject {
  @Published var appInfos: [AppInfo] = []
  @Published var selectedIdx: Int = 0
  
  private let viewContext: NSManagedObjectContext
  
  init(viewContext: NSManagedObjectContext) {
    self.viewContext = viewContext
    fetchAppInfos()
  }
  
  var appTitle: String {
    get {
      if !appInfos.isEmpty {
        appInfos[selectedIdx].descriptions?.title ?? ""
      } else {
        ""
      }
    }
    set {
      if !appInfos.isEmpty {
        appInfos[selectedIdx].descriptions?.title = newValue
      }
    }
  }
  
  var appIntro: String {
    get {
      if !appInfos.isEmpty {
        appInfos[selectedIdx].descriptions?.intro ?? ""
      } else { "" }
    }
    set { if !appInfos.isEmpty { appInfos[selectedIdx].descriptions?.intro = newValue } }
  }
  
  func appLogo(_ appInfo: AppInfo) -> NSImage? {
    guard let logo = appInfo.logo else { return nil }
    
    return NSImage(data: logo)
  }
  
  func onMoveAppInfo(fromOffsets source: IndexSet, toOffset destination: Int) {
    appInfos.move(fromOffsets: source, toOffset: destination)
    reinitAppInfoIndex()
    saveContext(.move)
  }
  
  /// ReInitializes AppInfo's indexes with original orders in AppInfo
  func reinitAppInfoIndex() {
    for (index, appInfo) in appInfos.enumerated() {
      appInfo.index = Int16(index)
    }
  }
  
  func fetchAppInfos() {
    let request: NSFetchRequest<AppInfo> = AppInfo.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \AppInfo.index, ascending: true)]
    // The reason for using the viewContext.perform block is that CoreData follows the Thread-Confined pattern.
    // This means that all operations on the same managed object context must be performed on the same thread.
    // Typically, an app renders the UI and handles user events on the main thread, so the CoreData context is also created on the main thread.
    // However, it is advisable to perform CoreData operations (object creation, updating, deletion, etc.) on a background thread.
    // This way, the main thread is not blocked, and the UI can maintain responsiveness.
    // This block enables tasks to be safely performed on a background thread.
    // All operations on the context are executed within the perform block, and once this task is completed, it switches back to the main thread.
    viewContext.perform {
      do {
        self.appInfos = try self.viewContext.fetch(request)
      } catch {
        print("Error fetching app infos: \(error)")
      }
    }
  }
  
  /// Convert NSImage to Data type
  func convertNSImageToData(_ image: NSImage) -> Data? {
    guard let tiffRepresentation = image.tiffRepresentation else { return nil }
    guard let bitmapImageRep = NSBitmapImageRep(data: tiffRepresentation) else {
      return nil
    }
    
    return bitmapImageRep.representation(using: .png, properties: [:])
  }
  
  func getIcon(application: String) -> NSImage? {
    guard let path = NSWorkspace.shared.fullPath(forApplication: application)
    else { return nil }
    
    return getIcon(file: path)
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
  
  func addApp() {
    guard let panel = openPanel(type: [.application]) else { return }
    if panel.runModal() == .OK {
      guard let url = panel.urls.first else { return }
      if let appName = url.pathComponents.last {
        let name = appName.components(separatedBy: ".")[0]
        let logo = getIcon(application: appName)
        addAppInfo(name: name, logo: logo ?? NSImage(resource: .figma))
      }
    }
  }
  
  func makeNewAppInfo(name: String, logo: NSImage) -> AppInfo {
    let newAppInfo = AppInfo(context: self.viewContext)
    newAppInfo.name = name
    if let logoData = self.convertNSImageToData(logo) {
      newAppInfo.logo = logoData
    }
    newAppInfo.index = Int16(self.appInfos.count)
    newAppInfo.id = UUID()
    
    let newAppDescription = self.makeNewAppDescription(name: name)
    newAppInfo.descriptions = newAppDescription
    
    return newAppInfo
  }
  
  func makeNewAppDescription(name: String) -> AppDescription {
    let newAppDescription = AppDescription(context: self.viewContext)
    newAppDescription.title = name + String(self.appInfos.count)
    newAppDescription.subTitle = name + "Subtitle" + String(self.appInfos.count)
    
    return newAppDescription
  }

  func addAppInfo(name: String, logo: NSImage) {
    if !appInfos.contains(where: { $0.name == name }) {
      viewContext.perform {
        let newAppInfo = self.makeNewAppInfo(name: name, logo: logo)
        self.saveContext(.add)
      }
    }
  }

  func deleteAppInfo(offset: IndexSet) {
    viewContext.perform {
      offset.forEach { index in
        let appInfo = self.appInfos[index]
        self.viewContext.delete(appInfo)
      }
      self.reinitAppInfoIndex()
      self.saveContext(.delete)
      self.fetchAppInfos()
    }
  }

  func saveContext(_ mode: Contexts) {
    var modeString: String {
      switch mode {
        case .save:
          return "saving"
        case .delete:
          return "deleting"
        case .add:
          return "adding"
        case .move:
          return "moving"
      }
    }

    do {
      try viewContext.save()
      fetchAppInfos()
    } catch {
      print("Error \(mode) app infos: \(error)")
    }
  }
}

enum Contexts {
  case save, delete, add, move
}
