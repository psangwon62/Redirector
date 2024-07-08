//
//  TestView.swift
//  Redirector
//
//  Created by 박상원 on 6/8/24.
//

import SwiftUI

struct TestView: View {
  @ObservedObject var viewModel: TestViewModel

  var body: some View {
    HStack {
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
      List {
        Form {
          TextField(AppStrings.title, text: $viewModel.appTitle)
          TextField(AppStrings.description, text: $viewModel.appIntro, axis: .vertical)
            .lineLimit(5, reservesSpace: true)
        }
      }
    }
  }

  @ViewBuilder
  func appLabel(appInfo: AppInfo) -> some View {
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

  var addAppButton: some View {
    Button {
      viewModel.addApp()
    } label: {
      Image(systemName: SFSymbols.plus)
    }
//    .disabled(viewModel.addButtonDisabled)
  }

  var deleteButton: some View {
    Button {
      viewModel.deleteAppInfo(offset: IndexSet([viewModel.selectedIdx]))
    } label: {
      Image(systemName: SFSymbols.minus)
        .frame(height: 16)
        .contentShape(Rectangle())
    }
//    .disabled(viewModel.deleteButton)
  }

  var updateAppButton: some View {
    HStack {
      addAppButton
      deleteButton
      Spacer()
    }
    .padding(Sizes.Paddings.quarter)
    .buttonStyle(BorderlessButtonStyle())
  }
}

#Preview {
  TestView(viewModel: TestViewModel(viewContext: PersistenceController.shared.container.viewContext))
}
