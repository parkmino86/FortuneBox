//
//  EmojiSpinnerView.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import SwiftUI

struct EmojiSpinnerView: View {
    @ObservedObject var viewModel: EmojiSpinnerViewModel
    let onComplete: () -> Void

    var body: some View {
        HStack {
            ForEach(viewModel.spinnerItems.indices, id: \.self) { index in
                SpinnerItemView(viewModel: viewModel.spinnerItems[index])
            }
        }
        .onChange(of: viewModel.allSpinnersCompleted) {
            if viewModel.allSpinnersCompleted {
                onComplete()
            }
        }
    }
}
