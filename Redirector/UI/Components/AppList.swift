//
//  AppList.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import CoreData
import SwiftUI

struct AppList: View {
  @ObservedObject var viewModel: AppSettingViewModelDeprecated
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AppInfo.index, ascending: true)],
    animation: .default
  ) private var items: FetchedResults<AppInfo>

  var body: some View {
    VStack {
      List /* (selection: $viewModel.selectedIndex) */ {
        Section(header: Text(AppStrings.apps)) {
          ForEach(items) { item in
            Text(item.name ?? "newApp")
          }
//          ForEach(0 ..< viewModel.appInfosCount, id: \.self) { index in
//            appLabel(index)
//          }
//          .onMove { indices, newOffset in
//            viewModel.onMoveUsers(fromOffsets: indices, toOffset: newOffset)
//          }
        }
        .border(.black)
      }
      .border(SeparatorShapeStyle())
    }
    .overlay(alignment: .bottom) {
      updateAppButton
    }
    .frame(width: Sizes.SettingComponents.appListWidth)
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }

  private func addItem() {
    guard let panel = openPanel(type: [.application]) else { return }
    if panel.runModal() == .OK {
      guard let url = panel.urls.first else { return }
      if let appName = url.pathComponents.last {
        let name = appName.components(separatedBy: ".")[0]
        if items.contains(where: { $0.name == name }) {
        } else {
          let newAppInfo = AppInfo(context: viewContext)
          let newAppDescription = AppDescription(context: viewContext)
          newAppInfo.name = name + String(items.count)
          newAppInfo.index = Int16(items.count - 1)
          newAppInfo.id = UUID()
          newAppInfo.descriptions = newAppDescription
          newAppDescription.title = "newApp" + String(items.count)
          newAppDescription.subTitle = "newAppSubtitle" + String(items.count)
          do {
            try viewContext.save()
          } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
          }
//          selectedIndex = list.count - 1
        }
      }
    }
  }

  @ViewBuilder
  func appLabel(_ index: Int) -> some View {
    Label {
      Text(viewModel.appInfos[index].name!)
        .padding(.leading, Sizes.Paddings.half)
        .lineLimit(1)
    } icon: {
//      AppIcon(image: viewModel.appImage(index))
    }
    .padding(.leading, Sizes.Paddings.half)
    .listRowSeparator(.hidden)
    .listRowInsets(.none)
    .onTapGesture { viewModel.updateSelectedIndex(index) }
  }

  var addAppButton: some View {
    Button(action: viewModel.addApp) {
      Image(systemName: SFSymbols.plus)
    }
    .disabled(viewModel.addButtonDisabled)
  }

  var removeAppButton: some View {
    Button(action: viewModel.removeApp) {
      Image(systemName: SFSymbols.minus)
    }
    .disabled(viewModel.removeButtonDisabled)
  }

  var updateAppButton: some View {
    HStack {
//      addAppButton
      Button(action: addItem) {
        Image(systemName: SFSymbols.plus)
      }
      removeAppButton
      Spacer()
    }
    .padding(Sizes.Paddings.quarter)
    .buttonStyle(BorderlessButtonStyle())
  }
}
