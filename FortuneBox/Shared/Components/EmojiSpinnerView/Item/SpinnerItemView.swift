//
//  SpinnerItemView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/19/25.
//

import SwiftUI

struct SpinnerItemView: View {
    @ObservedObject var viewModel: SpinnerItemViewModel

    var body: some View {
        Text(viewModel.currentEmoji)
            .font(.system(size: 64))
            .onAppear {
                viewModel.startSpinning()
            }
    }
}
