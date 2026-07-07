//
//  AppTheme.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String {
        rawValue
    }
    
    var titleKey: LocalizedStringKey {
        switch self {
            case .system: return "theme_system"
            case .light: return "theme_light"
            case .dark: return "theme_dark"
        }
    }
    
    var iconName: String {
        switch self {
            case .system: return "iphone"
            case .light: return "sun.max"
            case .dark: return "moon"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self  {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
        }
    }
}
