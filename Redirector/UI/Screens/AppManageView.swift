//
//  AppManageView.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI

struct AppManageView: View {
  @StateObject var viewModel: AppSettingViewModelDeprecated = .init()

  var body: some View {
    HStack(spacing: Sizes.Paddings.half) {
//      Text("hihi")
      AppList(viewModel: viewModel)
//      DescriptionEditForm(viewModel: viewModel)
    }
    .padding()
  }
}


#Preview {
  AppManageView()
}
