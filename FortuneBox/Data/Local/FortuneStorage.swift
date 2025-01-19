//
//  FortuneStorage.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation

final class FortuneStorage {
    static let shared = FortuneStorage()
    private init() {}

    private let fileName = "fortune-box"
    private let fileExtension = "json"

    func fetchRandomFortune() -> Fortune? {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("⚠️ JSON 파일 '\(fileName).\(fileExtension)'을 찾을 수 없습니다.")
            return nil
        }

        do {
            let data = try Data(contentsOf: path)
            let fortunes = try JSONDecoder().decode([Fortune].self, from: data)
            return fortunes.randomElement()
            
        } catch let DecodingError.dataCorrupted(context) {
            print("⚠️ JSON 데이터 손상: \(context.debugDescription)")
            
        } catch let DecodingError.keyNotFound(key, context) {
            print("⚠️ 키 '\(key.stringValue)'를 찾을 수 없음: \(context.debugDescription)")
            
        } catch let DecodingError.typeMismatch(type, context) {
            print("⚠️ 타입 불일치 '\(type)': \(context.debugDescription)")
            
        } catch let DecodingError.valueNotFound(value, context) {
            print("⚠️ 값 '\(value)'를 찾을 수 없음: \(context.debugDescription)")
            
        } catch {
            print("⚠️ JSON 디코딩 실패: \(error.localizedDescription)")
        }
        
        return nil
    }
}
