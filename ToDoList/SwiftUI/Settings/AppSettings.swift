//
//  AppSettings.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import SwiftUI

final class AppSettings: ObservableObject {
    @AppStorage("appTheme") private var storedTheme: String = AppTheme.system.rawValue
    @AppStorage("appLanguage") private var storedLanguage: String = AppLanguage.system.rawValue
    
    var theme: AppTheme {
        get {
            AppTheme(rawValue: storedTheme) ?? .system
        }
        set {
            storedTheme = newValue.rawValue
            objectWillChange.send()
        }
    }
    
    var language: AppLanguage {
        get {
            AppLanguage(rawValue: storedLanguage) ?? .system
        }
        set {
            storedLanguage = newValue.rawValue
            objectWillChange.send()
        }
    }
}
