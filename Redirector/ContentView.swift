//
//  ContentView.swift
//  Redirector
//
//  Created by 박상원 on 6/3/24.
//

import CoreData
import SwiftUI

struct ContentView: View {
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
          } label: {
            Text(item.name!)
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
//    .onAppear {
//      for i in 0..<items.count {
//        deleteItems(offsets: IndexSet([0]))
//      }
//    }
  }

  private func addItem() {
    withAnimation {
      let newAppInfo = AppInfo(context: viewContext)
      newAppInfo.name = "newItem" + String(items.count)
      newAppInfo.index = Int16(items.count - 1)
      newAppInfo.id = UUID()
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
