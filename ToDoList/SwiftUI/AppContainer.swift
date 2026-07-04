//
//  AppContainer.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 04.07.2026.
//

import Foundation

final class AppContainer {
    let coreDataStack: CoreDataStack
    let urlSession: URLSession
    let userDefaults: UserDefaults
    
    init(
        coreDataStack: CoreDataStack = .shared,
        urlSession: URLSession = .shared,
        userDefaults: UserDefaults = .standard
    ) {
        self.coreDataStack = coreDataStack
        self.urlSession = urlSession
        self.userDefaults = userDefaults
    }
    
    
}
