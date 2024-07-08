//
//  TrapezoidGroup.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI
func openApp(_ named: String) {
  NSWorkspace.shared.launchApplication(named)
}
enum Location {
  case plan, design, app, server
}
// MARK: - TrapezoidGroup
struct TrapezoidGroup: View {
  let location: Location
  @Binding var hovered: [Bool]
  var screenwidth: CGFloat
  let titleSize: CGFloat = 80
  var imagePadding: CGFloat { hovered == [false, false, false, false] ? 80 : 50 }
  let trapezoidOpacity: CGFloat = 0.6
  let subviewMaterial: Material = .regular
  let viewOffset: CGFloat = -80
  let viewanimation: Animation = .snappy

  var body: some View {
    Group {
      switch location {
        case .plan:
          ZStack {
            LeftTrapezoid()
              .fill(Color.background)
              .opacity(trapezoidOpacity)
            VStack {
              Text(" Plan")
                .font(.system(size: titleSize))
                .foregroundStyle(.white)
              Image("Notion")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, imagePadding)
            }
            .offset(y: viewOffset)
          }
        case .design:
          ZStack {
            Trapezoid()
              .fill(Color.background)
              .opacity(trapezoidOpacity)
            VStack {
              Text("   Design")
                .font(.system(size: titleSize))
                .foregroundStyle(.white)
              Image("Figma")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, imagePadding)
            }
            .offset(y: viewOffset)
          }
        case .app:
          ZStack {
            Trapezoid()
              .fill(Color.background)
              .opacity(trapezoidOpacity)
            VStack {
              Text("  App")
                .font(.system(size: titleSize))
                .foregroundStyle(.white)
              Image("Xcode")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, imagePadding)
            }
            .offset(y: viewOffset)
          }
        case .server:
          ZStack {
            RightTrapezoid(isHovered: $hovered[3])
              .fill(Color.background)
              .opacity(trapezoidOpacity)
            VStack {
              Text("   Server")
                .font(.system(size: titleSize))
                .foregroundStyle(.white)
              Image("Swagger")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, imagePadding)
            }
            .offset(y: viewOffset)
          }
      }
    }
    // Trapezoid overlay for border
    .overlay {
      Group {
        switch location {
          case .plan:
            LeftTrapezoid()
              .strokeBorder(Color.white, lineWidth: 10)
              .scaleEffect(1.03, anchor: .trailing)
              .offset(x: 3.5)
          case .design:
            Trapezoid()
              .strokeBorder(Color.black, lineWidth: 10)
              .scaleEffect(1.01)
          case .app:
            Trapezoid()
              .strokeBorder(Color.blue, lineWidth: 10)
              .scaleEffect(1.01)
          case .server:
            RightTrapezoid(isHovered: $hovered[3])
              .strokeBorder(Color.green, lineWidth: 10)
              .scaleEffect(1.01)
        }
      }
    }
    .onTapGesture {
      switch location {
        case .plan:
          openApp("Notion")
        case .design:
          openApp("Figma")
        case .app:
          openApp("Xcode")
        case .server:
          openApp("Google Chrome")
      }
    }
    .zIndex(3)
    .onHover { hovering in
      withAnimation {
        if hovering {
          switch location {
            case .plan:
              hovered = [true, false, false, false]
            case .design:
              hovered = [false, true, false, false]
            case .app:
              hovered = [false, false, true, false]
            case .server:
              hovered = [false, false, false, true]
          }
        }
      }
    }
    // Trapezoid for Description
    Group {
      switch location {
        case .plan:
          if hovered[0] {
            ZStack {
              SubTrapezoid()
                .foregroundStyle(subviewMaterial)
              VStack {
                Text("    서비스 기획")
                  .font(.system(size: titleSize / 2, weight: .semibold))
                  .padding(.bottom, 10)
                Text("     Service Planning")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 30)
                Text("   김시은, 김혜린")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 60)
                Group {
                  Text(" Whistle 기획의 정수,")
                  HStack(spacing: 8) {
                    Text(" Notion 둘러보기")
                    Image(systemName: "chevron.forward")
                  }
                }
                .font(.system(size: titleSize / 4))
              }
              .offset(y: viewOffset)
            }
            .zIndex(1)
            .transition(.asymmetric(insertion: .slide.combined(with: .opacity.animation(.easeIn)), removal: .identity)).animation(viewanimation)
          }
        case .design:
          if hovered[1] {
            ZStack {
              SubTrapezoid()
                .foregroundStyle(subviewMaterial)
              VStack {
                Text("    서비스 디자인")
                  .font(.system(size: titleSize / 2, weight: .semibold))
                  .padding(.bottom, 10)
                Text("     Service Design")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 30)
                Text("   이연정, 오세희")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 60)
                Group {
                  Text(" 디자인의 모든 것,")
                  HStack(spacing: 8) {
                    Text(" Figma 둘러보기")
                    Image(systemName: "chevron.forward")
                  }
                }
                .font(.system(size: titleSize / 4))
              }
              .offset(y: viewOffset)
            }
            .zIndex(1)
            .transition(.asymmetric(insertion: .slide.combined(with: .opacity.animation(.easeIn)), removal: .identity))
            .animation(viewanimation)
          }
        case .app:
          if hovered[2] {
            ZStack {
              SubTrapezoid()
                .foregroundStyle(subviewMaterial)
              VStack {
                Text("    iOS 개발")
                  .font(.system(size: titleSize / 2, weight: .semibold))
                  .padding(.bottom, 10)
                Text("     iOS Development")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 30)
                Text("   박상원, 최유진")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 60)
                Group {
                  Text(" 좋은 코드, 깨끗한 코드.")
                  HStack(spacing: 8) {
                    Text(" Xcode 둘러보기")
                    Image(systemName: "chevron.forward")
                  }
                }
                .font(.system(size: titleSize / 4))
              }
              .offset(y: viewOffset)
            }
            .zIndex(1)
            .transition(.asymmetric(insertion: .slide.combined(with: .opacity.animation(.easeIn)), removal: .identity))
            .animation(viewanimation)
          }
        case .server:
          if hovered[3] {
            ZStack {
              RightSubTrapezoid()
                .foregroundStyle(subviewMaterial)
              VStack {
                Text("    백엔드 개발")
                  .font(.system(size: titleSize / 2, weight: .semibold))
                  .padding(.bottom, 10)
                Text("     Backend Development")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 30)
                Text("   이연우, 이주원")
                  .font(.system(size: titleSize / 3, weight: .semibold))
                  .padding(.bottom, 60)
                Group {
                  Text(" 더 빠르게, 더 든든하게.")
                  HStack(spacing: 8) {
                    Text(" Swagger 둘러보기")
                    Image(systemName: "chevron.forward")
                  }
                }
                .font(.system(size: titleSize / 4))
              }
              .offset(y: viewOffset)
            }
            .zIndex(1)
            .transition(.asymmetric(insertion: .slide.combined(with: .opacity.animation(.easeIn)), removal: .identity))
            .animation(viewanimation)
          }
      }
    }
    .onTapGesture {
      switch location {
        case .plan:
          openApp("Notion")
        case .design:
          openApp("Figma")
        case .app:
          openApp("Xcode")
        case .server:
          openApp("Google Chrome")
      }
    }
  }
}
