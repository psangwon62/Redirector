//
//  AppInfoView.swift
//  Redirector
//
//  Created by 박상원 on 6/6/24.
//

import SwiftUI

class AppInfoViewModel: ObservableObject {
  let manager = AppInfoManager()

  @Published var appInfos = [AppInfo]()
  @Published var appDescription = [AppDescription]()
}

struct AppInfoView: View {
  @ObservedObject var appInfoViewModel = AppInfoViewModel()
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  AppInfoView()
}
