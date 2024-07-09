//
//  AppManageView.swift
//  Redirector
//
//  Created by 박상원 on 6/8/24.
//

import SwiftUI

struct AppManageView: View {
  @ObservedObject var viewModel: AppManageViewModel

  var body: some View {
    HStack(spacing: Sizes.Paddings.half) {
      appList
      appDetailForm
    }
    .padding()
  }
}

extension AppManageView {
  private var appList: some View {
    VStack {
      List(selection: $viewModel.selectedIdx) {
        ForEach(0 ..< viewModel.appInfos.count, id: \.self) { index in
          appLabel(appInfo: viewModel.appInfos[index])
        }
        .onMove { indices, newOffset in
          viewModel.onMoveAppInfo(fromOffsets: indices, toOffset: newOffset)
        }
      }
    }
    .border(SeparatorShapeStyle())
    .overlay(alignment: .bottom) {
      updateAppButton
    }
    .frame(width: Sizes.SettingComponents.appListWidth)
  }

  private var appDetailForm: some View {
    List {
      Form {
        Text(String(viewModel.appIndex))
        TextField(AppStrings.title, text: $viewModel.appTitle)
        TextField(AppStrings.description, text: $viewModel.appIntro, axis: .vertical)
          .lineLimit(5, reservesSpace: true)
      }
    }
  }

  @ViewBuilder
  private func appLabel(appInfo: AppInfo) -> some View {
    Label {
      Text(appInfo.name ?? "")
        .padding(.leading, Sizes.Paddings.half)
        .lineLimit(1)
    } icon: {
      AppIcon(image: viewModel.appLogo(appInfo))
    }
    .padding(.leading, Sizes.Paddings.half)
    .listRowSeparator(.hidden)
    .listRowInsets(.none)
    .contentShape(Rectangle())
  }
  
  private var addAppButton: some View {
    Button {
      viewModel.addApp()
    } label: {
      Image(systemName: SFSymbols.plus)
        .bottomToolbarButton()
    }
    .disabled(viewModel.disableAddBtn)
  }

  private var deleteAppButton: some View {
    Button {
      viewModel.deleteAppInfo()
    } label: {
      Image(systemName: SFSymbols.minus)
        .bottomToolbarButton()
    }
    .disabled(viewModel.disableDelBtn)
  }
  
  private var updateAppButton: some View {
    HStack {
      addAppButton
      deleteAppButton
      Spacer()
    }
    .padding(Sizes.Paddings.quarter)
    .buttonStyle(BorderlessButtonStyle())
  }
}
