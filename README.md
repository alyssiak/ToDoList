# ToDoList — SwiftUI Task Manager

A SwiftUI task manager inspired by Apple Notes/Reminders. The project was originally built with UIKit and later migrated to SwiftUI while keeping a VIPER-like architecture.

## Features

- Create, edit, delete, and complete tasks
- Persist tasks with CoreData
- Add descriptions, creation dates, and reminders
- Schedule local notifications with UserNotifications
- Automatically clear expired and completed reminders
- Mark tasks as important
- Group tasks into Important, Tasks, and Completed sections
- Search tasks by title and description
- Switch between System, Light, and Dark themes
- Switch app language between English and Russian
- Import sample tasks from API
- Unit tests for app language logic, presenter behavior, and CoreData repository

## Tech Stack

- Swift
- SwiftUI
- CoreData
- UserNotifications
- URLSession
- UserDefaults / AppStorage
- XCTest
- Git / GitHub Pull Requests

## Architecture

The app uses a VIPER-like structure adapted for SwiftUI:

- View — SwiftUI screens and UI rendering
- Presenter — presentation logic, search, and user actions
- Interactor — business logic and use cases
- Repository — CoreData persistence
- Router — navigation and sheet presentation state
- Assembly / AppContainer — dependency injection

## Testing

The project includes unit tests for:

- App language task count formatting
- Presenter behavior with mocked interactor/router
- CoreData repository using an in-memory store

## API

The app can import sample tasks from DummyJSON:

https://dummyjson.com/todos

## Requirements

- Xcode 16+
- iOS 17+
- Swift 5+

## Run

1. Open `ToDoList.xcodeproj`
2. Select an iPhone simulator
3. Run the app with `Cmd + R`
4. Run tests with `Cmd + U` 
