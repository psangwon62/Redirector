//
//  RightTrapezoid.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI

/// RightSide Trapezoid
///
/// - Parameters:
///   - isHovered: Flag for mouse pointer hover

struct RightTrapezoid: InsettableShape {
  var insetAmount = 0.0
  func inset(by amount: CGFloat) -> RightTrapezoid {
    var trapezoid = self
    trapezoid.insetAmount += amount
    return trapezoid
  }

  @Binding var isHovered: Bool
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      let horizontalOffset: CGFloat = rect.width * 0.25
      path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX + horizontalOffset, y: rect.minY))
      if isHovered {
        path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.maxY))
      } else {
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      }
      path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
    }
  }
}

struct RightSubTrapezoid: InsettableShape {
  var insetAmount = 0.0
  func inset(by amount: CGFloat) -> RightSubTrapezoid {
    var trapezoid = self
    trapezoid.insetAmount += amount
    return trapezoid
  }

  func path(in rect: CGRect) -> Path {
    Path { path in
      let horizontalOffset: CGFloat = rect.width * 0.25
      path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
    }
  }
}

// #Preview {
//  RightTrapezoid()
// }
