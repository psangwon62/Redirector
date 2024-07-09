//
//  AppInfoService.swift
//  Redirector
//
//  Created by 박상원 on 7/8/24.
//

import Cocoa
import SwiftUI

class AppInfoService: ObservableObject {
  static let shared = AppInfoService(coreDataManager: CoreDataManager.shared)

  private let coreDataManager: CoreDataManager
  @Published private(set) var appInfos: [AppInfo] = []

  init(coreDataManager: CoreDataManager) {
    self.coreDataManager = coreDataManager
    fetchAppInfos()
  }

  func fetchAppInfos() {
    coreDataManager.viewContext.perform {
      let fetchedInfos = self.coreDataManager.fetchAppInfos()
      // UI 관련 정보이므로 메인 스레드에서 업데이트
      DispatchQueue.main.async {
        self.appInfos = fetchedInfos
      }
    }
  }

  private func makeNewAppInfo(name: String, logo: NSImage) -> AppInfo {
    let newAppInfo = AppInfo(context: coreDataManager.viewContext)
    newAppInfo.name = name
    if let logoData = ImageUtil.convertNSImageToData(logo) {
      newAppInfo.logo = logoData
    }
    newAppInfo.index = Int16(appInfos.count)
    newAppInfo.id = UUID()

    let newAppDescription = AppDescription(context: coreDataManager.viewContext)
    newAppDescription.title = name
    newAppDescription.subTitle = name + "Subtitle"
    newAppInfo.descriptions = newAppDescription

    return newAppInfo
  }

  func addAppInfo(name: String, logo: NSImage) -> Bool {
    guard !appInfos.contains(where: { $0.name == name }) else { return false }

    let newAppInfo = makeNewAppInfo(name: name, logo: logo)
    coreDataManager.viewContext.insert(newAppInfo)
    coreDataManager.saveContext()
    fetchAppInfos()
    return true
  }

  func deleteAppInfo(at index: Int) {
    let appInfo = appInfos[index]
    coreDataManager.viewContext.perform {
      self.coreDataManager.viewContext.delete(appInfo)
      // 마지막 원소가 아닐 때만 index rearrange
      if index != (self.appInfos.count - 1) {
        self.rearrangeAppInfoIndex()
      } else {
        self.coreDataManager.saveContext()
        self.fetchAppInfos()
      }
    }
  }

  func swapAppInfoIndex(source: [AppInfo]) {
    coreDataManager.viewContext.perform {
      for (index, appInfo) in source.enumerated() {
        appInfo.index = Int16(index)
      }
      self.coreDataManager.saveContext()
      self.fetchAppInfos()
    }
  }

  func rearrangeAppInfoIndex() {
    coreDataManager.viewContext.perform {
      let nonFaultAppInfo = self.appInfos.filter { !$0.isFault }
      for (index, appInfo) in nonFaultAppInfo.enumerated() {
        appInfo.index = Int16(index)
      }
      self.coreDataManager.saveContext()
      self.fetchAppInfos()
    }
  }
}
