//
//  ContentView.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//

import CoreData
import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = AppSettingViewModelDeprecated()
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AppInfo.index, ascending: true)],
    animation: .default
  )
  private var items: FetchedResults<AppInfo>

  var body: some View {
    NavigationView {
      List {
        ForEach(items) { item in
          NavigationLink {
            Text("Item at \(item.id)")
            Text(item.descriptions?.title ?? "newApp")
          } label: {
            HStack {
              Text(item.name!)
            }
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem {
          Button(action: addItem) {
            Label("Add App", systemImage: "plus")
          }
        }
      }
      Text("Select an item")
    }
    .onAppear {
      for i in 0 ..< items.count {
        deleteItems(offsets: IndexSet([0]))
      }
    }
  }

  private func addItem() {
    withAnimation {
      let newAppInfo = AppInfo(context: viewContext)
      let newAppDescription = AppDescription(context: viewContext)
      newAppInfo.name = "newItem" + String(items.count)
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
    }
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
}

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

////
////  ContentView.swift
////  Redirector
////
////  Created by 박상원 on 12/2/23.
////
//
//
//// 호버를 뷰모델로 빼고,
//
// import Cocoa
// import SwiftUI
//
// struct ContentView: View {
//  @State var hovered = [false, false, false, false]
//  @State var timer: Timer? = nil
//  @State var isHovered: Bool = false
//  @State private var rotation: Angle = .degrees(0)
//
//  var body: some View {
//    GeometryReader { proxy in
//      ZStack {
//        Image("background")
//          .resizable()
//          .scaledToFill()
//        HStack(spacing: 5) {
//          TrapezoidGroup(location: .plan, hovered: $hovered, screenwidth: proxy.size.width)
//          TrapezoidGroup(location: .design, hovered: $hovered, screenwidth: proxy.size.width)
//          TrapezoidGroup(location: .app, hovered: $hovered, screenwidth: proxy.size.width)
//          TrapezoidGroup(location: .server, hovered: $hovered, screenwidth: proxy.size.width)
//        }
//        VStack {
//          Spacer()
//          ZStack {
//            LinearGradient(colors: [.primaryDefaultDark, .secondaryDefaultDark], startPoint: .leading, endPoint: .trailing)
//              .frame(width: proxy.size.width, height: isHovered ? 200 : 150)
//            HStack(alignment: .center) {
//              Image("Arc")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 35, height: 35)
//                .opacity(isHovered ? 1 : 0)
//                .rotationEffect(rotation)
//                .padding(.trailing, 10)
//                .offset(y: 2)
//                .onAppear {
//                  // Start a timer to update the rotation every second
//                  let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//                    withAnimation(.easeInOut(duration: 1)) {
//                      rotation += .degrees(360)
//                    }
//                  }
//                  // Make sure to invalidate the timer when the view is no longer visible
//                  RunLoop.main.add(timer, forMode: .common)
//                }
//              Text("Whistle 웹사이트 바로가기")
//                .font(.system(size: 30, weight: .semibold))
//              Image(systemName: "chevron.forward")
//                .font(.system(size: 25, weight: .semibold))
//            }
//            .foregroundStyle(Color.black)
//            .padding(.bottom, 60)
//          }
//          .onHover(perform: { isHovered in
//            withAnimation {
//              hovered = [false, false, false, false]
//              self.isHovered = isHovered
//            }
//          })
//          .onTapGesture {
//            openApp("Arc")
//          }
//        }
//      }
//      .onAppear {
//        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
//          if let timer = timer {
//            timer.invalidate()
//          }
//          timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { _ in
//            if NSWorkspace.shared.frontmostApplication?.localizedName != "Redirector" {
//              let apps = NSWorkspace.shared.runningApplications
//              for app in apps {
//                if app.localizedName == "Redirector" {
//                  if !app.isActive {
//                    app.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
//                  }
//                }
//              }
//              timer?.invalidate()
//            }
//          }
//        }
//      }
//    }
//  }
// }
//
// func openApp(_ named: String) {
//  NSWorkspace.shared.launchApplication(named)
// }
//
// #Preview {
//  ContentView()
// }
//
// enum Location {
//  case plan, design, app, server
// }
