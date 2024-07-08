//
//  DescriptionEditForm.swift
//  Redirector
//
//  Created by 박상원 on 6/5/24.
//

import SwiftUI

struct DescriptionEditForm: View {
  @ObservedObject var viewModel: AppSettingViewModelDeprecated

  var body: some View {
    List {
      Form {
//        TextField(AppStrings.title, text: $viewModel.appTitle)
//        TextField(AppStrings.description, text: $viewModel.appDescription, axis: .vertical)
//          .lineLimit(5, reservesSpace: true)
      }
    }
  }
}
