import Foundation

final class FortuneStorage {
    static let shared = FortuneStorage()
    private init() {}

    private let fortuneFileName = "fortunelist"
    private let fileExtension = "json"

    func fetchRandomFortune() -> Fortune? {
        guard let path = Bundle.main.url(forResource: fortuneFileName, withExtension: fileExtension) else {
            print("⚠️ JSON 파일을 찾을 수 없습니다.")
            return nil
        }

        do {
            let data = try Data(contentsOf: path)
            let fortunes = try JSONDecoder().decode([Fortune].self, from: data)
            return fortunes.randomElement()
        } catch {
            print("⚠️ JSON 디코딩에 실패했습니다: \(error.localizedDescription)")
            return nil
        }
    }
}
