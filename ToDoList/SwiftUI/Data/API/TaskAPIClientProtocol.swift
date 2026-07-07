//
//  TaskAPIClientProtocol.swift
//  TaskAPIClientProtocol
//
//  Created by Alice Kamyshenko on 06.07.2026.
//

import Foundation

protocol TaskAPIClientProtocol {
    func fetchSampleTasks() async throws -> [TaskSeed]
}
