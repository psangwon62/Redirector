//
//  BackgroundManageView.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct BackgroundManageView: View {
  // TODO: - AppStorage로 image 빼내기
  @State private var image: NSImage?
  var body: some View {
    VStack {
      if let image = image {
        Image(nsImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else {
        Text("이미지를 선택하세요")
      }

      Button("Finder에서 이미지 가져오기") {
        guard let panel = openPanel(type: [.image]) else {
          return
        }

        if panel.runModal() == .OK {
          guard let url = panel.urls.first else { return }
          self.image = NSImage(contentsOf: url)
        }
      }
    }
  }
}

#Preview {
  BackgroundManageView()
}

func openPanel(type: [UTType]) -> NSOpenPanel?{
  let panel = NSOpenPanel()
  panel.allowsMultipleSelection = false
  panel.canChooseDirectories = false
  panel.canChooseFiles = true
  panel.allowedContentTypes = type
  guard NSApp.keyWindow != nil else { return nil}

  return panel
}
