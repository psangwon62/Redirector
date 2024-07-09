//
//  AppManageViewModel.swift
//  Redirector
//
//  Created by 박상원 on 6/8/24.
//

import Combine
import CoreData
import SwiftUI

class AppManageViewModel: ObservableObject {
  @Published var appInfos: [AppInfo] = []
  @Published var selectedIdx: Int = 0

  private var cancellables = Set<AnyCancellable>()
  private let appInfoService: AppInfoService

  init(appInfoService: AppInfoService) {
    self.appInfoService = appInfoService
    bindToService()
  }

  private func bindToService() {
    appInfoService.$appInfos
      .receive(on: DispatchQueue.main)
      .assign(to: \.appInfos, on: self)
      .store(in: &cancellables)
  }

  var disableAddBtn: Bool { appInfos.count == 4 }

  var disableDelBtn: Bool { appInfos.count == 1 }

  var appIndex: Int { !appInfos.isEmpty ? Int(appInfos[selectedIdx].index) : 0 }

  var appTitle: String {
    get {
      guard isValidIndex else { return "" }
      return appInfos[selectedIdx].descriptions?.title ?? ""
    }
    set {
      guard isValidIndex else { return }
      appInfos[selectedIdx].descriptions?.title = newValue
    }
  }

  var appIntro: String {
    get {
      guard isValidIndex else { return "" }
      return appInfos[selectedIdx].descriptions?.intro ?? ""
    }
    set {
      guard isValidIndex else { return }
      appInfos[selectedIdx].descriptions?.intro = newValue
    }
  }

  private var isValidIndex: Bool {
    !appInfos.isEmpty && selectedIdx < appInfos.count
  }

  func appLogo(_ appInfo: AppInfo) -> NSImage? {
    guard let logo = appInfo.logo else { return nil }
    return NSImage(data: logo)
  }

  func updateSelectedIdx(by: Int) {
    selectedIdx = by
  }
  
  // MARK: - Manage AppInfos
  func addAppInfo(name: String, logo: NSImage) {
    if appInfoService.addAppInfo(name: name, logo: logo) {
      updateSelectedIdx(by: appInfos.count - 1)
    }
  }

  func deleteAppInfo() {
    appInfoService.deleteAppInfo(at: selectedIdx)
    // if selectedIdx is last element of AppInfos, decrease selectedIdx
    if selectedIdx == appInfos.count - 1 {
      updateSelectedIdx(by: selectedIdx - 1)
    }
    reinitAppInfoIndex()
  }

  /// move appinfos through list and rearrange them
  func onMoveAppInfo(fromOffsets source: IndexSet, toOffset destination: Int) {
    appInfos.move(fromOffsets: source, toOffset: destination)
    swapAppInfoIndex()
  }

  /// swap index between appinfos
  func swapAppInfoIndex() {
    appInfoService.swapAppInfoIndex(source: appInfos)
  }

  /// ReInitializes AppInfo's indexes with original orders in AppInfo
  func reinitAppInfoIndex() {
    appInfoService.rearrangeAppInfoIndex()
  }
  
  func addApp() {
    guard let panel = openPanel(type: [.application]) else { return }
    if panel.runModal() == .OK {
      guard let url = panel.urls.first else { return }
      addAppFrom(url: url)
    }
  }

  private func addAppFrom(url: URL) {
    if let appName = url.pathComponents.last {
      let name = appName.components(separatedBy: ".")[0]
      let logo = ImageUtil.getIcon(application: appName)
      addAppInfo(name: name, logo: logo ?? NSImage(resource: .figma))
    }
  }
}
