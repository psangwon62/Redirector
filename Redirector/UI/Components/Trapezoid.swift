//
//  Trapezoid.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI

struct Trapezoid: InsettableShape {
  var insetAmount = 0.0
  func inset(by amount: CGFloat) -> Trapezoid {
    var trapezoid = self
    trapezoid.insetAmount += amount
    return trapezoid
  }

  func path(in rect: CGRect) -> Path {
    Path { path in
      let horizontalOffset: CGFloat = rect.width * 0.25
      path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX + horizontalOffset, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
    }
  }
}

struct SubTrapezoid: InsettableShape {
  var insetAmount = 0.0
  func inset(by amount: CGFloat) -> SubTrapezoid {
    var trapezoid = self
    trapezoid.insetAmount += amount
    return trapezoid
  }

  func path(in rect: CGRect) -> Path {
    Path { path in
      let horizontalOffset: CGFloat = rect.width * 0.25
      path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX + horizontalOffset, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX - horizontalOffset, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
    }
  }
}

#Preview {
  Trapezoid()
}
