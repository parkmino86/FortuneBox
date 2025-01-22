//
//  GeminiService.swift
//  FortuneBox
//
//  Created by minoh.park on 1/20/25.
//

import GoogleGenerativeAI

final class GeminiService {
    static let shared = GeminiService()

    private let model: GenerativeModel
    private let apiKey = Secrets.apiKey
    private let modelName = "gemini-1.5-flash"

    private init() {
        self.model = GenerativeModel(name: modelName, apiKey: apiKey)
    }

    func generateContent(with prompt: String) async throws -> String {
        let response = try await model.generateContent(prompt)
        return response.text ?? "No content was generated."
    }
}
