//
//  TaskAPIClient.swift
//  TaskAPIClient
//
//  Created by Alice Kamyshenko on 06.07.2026.
//

import Foundation

final class TaskAPIClient: TaskAPIClientProtocol {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func fetchSampleTasks() async throws -> [TaskSeed] {
        guard let url = URL(
            string: "https://dummyjson.com/todos?limit=10"
        ) else {
            throw TaskAPIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard
            let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw TaskAPIError.invalidResponse
        }

        let responseModel = try JSONDecoder().decode(
            TodosResponse.self,
            from: data
        )

        return responseModel.todos.map {
            TaskSeed(
                title: $0.todo,
                isCompleted: $0.completed
            )
        }
    }
}

private struct TodosResponse: Decodable {
    let todos: [RemoteTodo]
}

private struct RemoteTodo: Decodable {
    let todo: String
    let completed: Bool
}

enum TaskAPIError: LocalizedError {
    case invalidURL
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        }
    }
}
