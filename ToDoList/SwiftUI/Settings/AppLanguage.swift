//
//  AppLanguage.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case english
    case russian
    
    var id: String {
        rawValue
    }
    
    var titleKey: LocalizedStringKey {
        switch self {
            case .system: return "language_system"
            case .english: return "language_english"
            case .russian: return "language_russian"
        }
    }

    func taskCountText(for count: Int) -> String {
        switch self {
        case .english:
            return count == 1 ? "\(count) task" : "\(count) tasks"

        case .russian:
            return russianTaskCountText(for: count)

        case .system:
            let languageCode = Locale.autoupdatingCurrent.language.languageCode?.identifier
            return languageCode == "ru"
            ? russianTaskCountText(for: count)
            : (count == 1 ? "\(count) task" : "\(count) tasks")
        }
    }

    private func russianTaskCountText(for count: Int) -> String {
        let remainder100 = count % 100
        let remainder10 = count % 10

        let word: String

        if remainder100 >= 11 && remainder100 <= 14 {
            word = "задач"
        } else {
            switch remainder10 {
            case 1:
                word = "задача"
            case 2...4:
                word = "задачи"
            default:
                word = "задач"
            }
        }

        return "\(count) \(word)"
    }
    
    var iconName: String {
            switch self {
            case .system:
                return "globe"
            case .english:
                return "textformat.abc"
            case .russian:
                return "textformat"
            }
        }
    
    var locale: Locale {
        switch self {
            case .system: return .autoupdatingCurrent
            case .english: return Locale(identifier: "en")
            case .russian: return Locale(identifier: "ru")
        }
    }
}
