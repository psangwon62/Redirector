//
//  SettingsView.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI

struct SettingsView: View {
  var body: some View {
    TabView {
//      BackgroundManageView()
//      .padding()
//      .tabItem {
//        Label("Background", systemImage: "photo.fill")
//      }

      AppManageView()
      .tabItem {
        Label("Apps", systemImage: "plus.app.fill")
      }
    }
    .frame(width: 800, height: 400)
  }
}

#Preview {
  SettingsView()
}
