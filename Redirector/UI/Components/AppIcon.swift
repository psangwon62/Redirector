//
//  AppIcon.swift
//  Redirector
//
//  Created by 박상원 on 5/7/24.
//

import SwiftUI

struct AppIcon: View {
  let image: NSImage?

  var body: some View {
    if let image = image {
      Image(nsImage: image)
        .resizable()
        .frame(width: Sizes.SettingComponents.appIconSize, height: Sizes.SettingComponents.appIconSize)
        .aspectRatio(contentMode: .fit)
    } else {
      EmptyView()
    }
  }
}

#Preview {
  AppIcon(image: .appStore)
}
