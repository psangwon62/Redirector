//
//  AppDescriptionsManager.swift
//  Redirector
//
//  Created by 박상원 on 6/6/24.
//

import Foundation

class AppDescriptionsManager {
  static let shared = AppDescriptionsManager()
  
  let context = PersistenceController.shared.container.viewContext
    
}
