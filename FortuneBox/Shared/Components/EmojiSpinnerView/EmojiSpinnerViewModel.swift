import Foundation
import Combine

final class EmojiSpinnerViewModel: ObservableObject {
    @Published var spinnerItems: [SpinnerItemViewModel] = []
    @Published var allSpinnersCompleted: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(fortune: Fortune) {
        guard !fortune.emojis.isEmpty else { return }

        self.spinnerItems = (0..<3).map { index in
            SpinnerItemViewModel(
                spinSpeed: 0.05 + 0.02 * Double(index),
                spinCount: 20 + 10 * index,
                finalEmoji: fortune.emojis[index % fortune.emojis.count]
            )
        }

        spinnerItems.publisher
            .flatMap { $0.$isFinished }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.allSpinnersCompleted = self?.spinnerItems.allSatisfy { $0.isFinished } ?? false
            }
            .store(in: &cancellables)
    }
}
