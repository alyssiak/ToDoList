//
//  AppLanguageTests.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 07.07.2026.
//

import XCTest
@testable import ToDoList

final class AppLanguageTests: XCTestCase {
    func testEnglishTaskCountText() {
        XCTAssertEqual(
            AppLanguage.english.taskCountText(for: 1),
            "1 task"
        )
        
        XCTAssertEqual(
            AppLanguage.english.taskCountText(for: 2),
            "2 tasks"
        )
    }
    
    func testRussianTaskCountText() {
            XCTAssertEqual(
                AppLanguage.russian.taskCountText(for: 1),
                "1 задача"
            )

            XCTAssertEqual(
                AppLanguage.russian.taskCountText(for: 2),
                "2 задачи"
            )

            XCTAssertEqual(
                AppLanguage.russian.taskCountText(for: 5),
                "5 задач"
            )

            XCTAssertEqual(
                AppLanguage.russian.taskCountText(for: 11),
                "11 задач"
            )

            XCTAssertEqual(
                AppLanguage.russian.taskCountText(for: 21),
                "21 задача"
            )
        }
}
