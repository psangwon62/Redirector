//
//  RedirectorViewModel.swift
//  Redirector
//
//  Created by 박상원 on 7/9/24.
//

import Foundation
import Combine
import Cocoa

class RedirectorViewModel: ObservableObject {
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
}
