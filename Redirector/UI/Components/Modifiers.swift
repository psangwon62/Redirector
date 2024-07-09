//
//  Modifiers.swift
//  Redirector
//
//  Created by 박상원 on 7/9/24.
//

import SwiftUI

struct BottomToolbarButtonStyleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(height: 16)
      .contentShape(Rectangle())
  }
}

extension View {
  func bottomToolbarButton() -> some View {
    modifier(BottomToolbarButtonStyleModifier())
  }
}
