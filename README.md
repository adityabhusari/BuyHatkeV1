# ByHatkeV1 - Todo App

## Overview

ByHatkeV1 is a SwiftUI-based Todo app that allows users to add, view, edit, and delete tasks (Todos). The app supports dark mode and integrates with SwiftData for storing todo items. It consists of a main screen to display tasks and an edit screen to update the task details.

## Features

- **Main Screen**: Displays a list of todos with titles, descriptions, and completion status.
![WhatsApp Image 2024-10-09 at 23 26 11 (1)](https://github.com/user-attachments/assets/eacdfe88-7321-42a7-91e1-4ceb92cd91b0)

- **Add Todo**: Users can add new todos with a title and description.
![WhatsApp Image 2024-10-09 at 23 26 11](https://github.com/user-attachments/assets/97e1e190-61e5-4848-a121-88a38a917780)

- **Edit Todo**: Users can edit existing todos' details such as title, description, and mark them as complete.
![WhatsApp Image 2024-10-09 at 23 26 12 (1)](https://github.com/user-attachments/assets/dc69f79d-f022-4dba-837b-0a6ea279d7e4)

- **Delete Todo**: Swipe to delete tasks.

![WhatsApp Image 2024-10-09 at 23 48 01](https://github.com/user-attachments/assets/57a75376-4aa7-475e-930d-43d5e7c914d5)

- **Dark Mode Toggle**: Users can switch between light and dark mode using a toggle.
![WhatsApp Image 2024-10-09 at 23 26 12 (2)](https://github.com/user-attachments/assets/687b83b4-724a-494c-a7cf-1d518a3af901)

## Main Screen (Todos List)

The main screen showcases all the tasks in a list format:

- Each task is displayed as a tile, including:
  - **Title** (Bolded and prominent)
  - **Description** (Shown if present)
  - **Completion Status** (Indicated by a checkmark icon for completed tasks)
  
- Key actions on the main screen:
  - **Add New Todo**: By pressing the "+" button in the toolbar, users can add new todos.
  - **Dark Mode Toggle**: A toggle is provided to enable or disable dark mode.
  - **Edit Todo**: Selecting a task navigates to the edit screen.
  - **Delete Todo**: Swipe on any task to delete it.

## New Todo Screen

- Accessible via the "+" button on the main screen.
- Users can fill in:
  - **Title** (Required)
  - **Description** (Optional, supports multiline input)
  
- The **Submit** button is enabled only when the title is filled in.
- The **Cancel** button allows users to exit without saving.

## Edit Todo Screen

- When users select a todo from the main list, they are navigated to the Edit Todo screen.
- Users can modify:
  - **Completion Status** (via a toggle)
  - **Title** and **Description**
  - **Creation Date and Time** (Displayed, but not editable)
  
- The **Submit** button updates the todo with the new details and returns to the main screen.
- The **Cancel** button allows exiting without saving changes.

## Getting Started

1. Clone the repository and open the project in Xcode.
2. Build and run the app on a simulator or device.
3. Add, edit, or delete tasks to experience the functionality.

## Requirements

- iOS 16.0+
- Swift 5.9
- Xcode 15+

## Code Explanation

The **ByHatkeV1** app is a simple todo list application built using SwiftUI and SwiftData. Below is a detailed breakdown of the code:

### The `Todo` Model

```swift
@Model
class Todo: Identifiable, Equatable {
    @Attribute(.unique) var id = UUID()    // Unique identifier for each todo
    var title: String                      // Title of the todo
    var desc: String                       // Description of the todo
    var isComplete: Bool                   // Status of the todo (completed or not)
    var dt: Date                           // Date and time the todo was created
    
    init(id: UUID = UUID(), title: String, desc: String, isComplete: Bool, dt: Date) {
        self.id = id
        self.title = title
        self.desc = desc
        self.isComplete = isComplete
        self.dt = dt
    }
}
```
  - The `@Model` and `@Attribute(.unique)` annotations are used for SwiftData integration to persist todo items.
  - The `Todo` class conforms to `Identifiable` so that SwiftUI can identify each todo item uniquely in a list.
  - The model also conforms to `Equatable` to support comparison between todos.

### The `TodoTile` View
The `TodoTile` is a reusable SwiftUI component that represents each todo item in a list.
```swift
struct TodoTile: View {
    @Bindable var todo: Todo
    
    let editAction: (Todo) -> ()
    var body: some View {
        HStack {
            Image(systemName: todo.isComplete ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 24, height: 24)
                .padding(4)
            VStack(alignment: .leading) {
                Text(todo.title)
                    .bold()
                    .font(.headline)
                if !todo.desc.isEmpty {
                    Text(todo.desc)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```
  - The view uses a `HStack` to horizontally arrange a completion checkmark and todo details (title and description).
  - If the todo is marked as complete, the icon changes to a filled checkmark `(checkmark.circle.fill)`.
  - The `VStack` organizes the todo title (bold) and description (optional) in a vertical stack.
  - The view is `@Bindable` so it automatically reflects changes when the todo data is updated.

### The `EditTodoView` View
This view allows users to edit an existing todo.
```swift
struct EditTodoView: View {
    @Environment(\.dismiss) var dismiss   // Dismisses the view when editing is done
    @Bindable var todo: Todo              // The todo being edited
    let editAction: (Todo) -> ()          // Action to save the edited todo
    
    var body: some View {
        Form {
            HStack {
                Text("Created on")
                Spacer()
                Text(todo.dt, style: .date)
                Text("at")
                Text(todo.dt, style: .time)
            }
            Toggle("Completed", isOn: $todo.isComplete)   // Toggle to mark the todo as completed
            Section("Title") {
                TextField("", text: $todo.title)           // Text field for editing the title
            }
            Section("Description") {
                TextField("", text: $todo.desc, axis: .vertical)
                    .lineLimit(5...10)                    // Multiline description field
            }
        }
        .navigationTitle("Edit")                           // Sets the title of the navigation bar
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    editAction(todo)                      // Calls the edit action to save changes
                    dismiss()                             // Dismisses the edit screen
                } label: {
                    Text("Submit")
                }
                .disabled(todo.title.isEmpty)             // Disables the button if the title is empty
            }
        }
    }
}
```
  - **Form**: The form contains editable fields like the title and description, and a toggle to mark completion.
  - **HStack**:  Displays the creation date and time of the todo (not editable).
  - **Submit Button**: The `Submit` button is disabled if the title is empty and saves the changes when clicked.
  - **Dismiss**: Uses `@Environment(\.dismiss)` to close the screen after editing.

### The `NewTodoView` View
This view allows users to add a new todo.
```swift
struct NewTodoView: View {
    @Environment(\.dismiss) var dismiss   // Dismisses the view when done
    @State var titleText = ""             // State for the title text field
    @State var descText = ""              // State for the description text field
    
    let addAction: (Todo) -> ()           // Action to add a new todo
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $titleText)       // Text field for the todo title
                Section("Description") {
                    TextField("", text: $descText, axis: .vertical)
                        .lineLimit(5...10)                // Multiline field for the description
                }
            }
            .navigationTitle("Add Todo")                   // Sets the title of the navigation bar
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addAction(Todo(title: titleText, desc: descText, isComplete: false, dt: .now))
                        dismiss()                         // Adds the new todo and dismisses the view
                    } label: {
                        Text("Submit")
                    }
                    .disabled(titleText.isEmpty)          // Disables the button if title is empty
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()                         // Dismisses without saving
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}
```
  - **Form**: Contains text fields for the title and description of the new todo.
  - **Submit Button**: Creates a new `Todo` with the entered title, description, and the current date.
  - **Cancel Button**: Allows the user to cancel the action without saving.

### The `ContentView` Model
The main view that lists all the todos and allows interaction such as adding and editing.

```swift
struct ContentView: View {
    @Environment(\.modelContext) private var context   // Data persistence context
    @Query var todos: [Todo]                           // Query to fetch all todos from storage
    
    @State var isShowingSheet = false                  // State for displaying the sheet to add a new todo
    @AppStorage("isDarkMode") private var isDarkMode = false // Persists dark mode preference
    
    func addTodo(todo: Todo) {
        withAnimation { context.insert(todo) }         // Adds a new todo to the data context with animation
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in               // Loops through all todos and displays them
                    NavigationLink {
                        EditTodoView(todo: todo, editAction: addTodo) // Navigates to edit screen
                    } label: {
                        TodoTile(todo: todo, editAction: addTodo)     // Displays each todo tile
                    }
                }
                .onDelete { idx in                     // Allows users to delete todos
                    for i in idx {
                        context.delete(todos[i])
                    }
                }
            }
            .navigationTitle("Todos")                   // Sets the navigation title
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingSheet = true           // Opens the sheet to add a new todo
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Toggle("Dark Mode", isOn: $isDarkMode) // Dark mode toggle
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                NewTodoView(addAction: addTodo)         // Presents the sheet for adding a new todo
            }
        }
    }
}
```
  - **List**: Displays all the todos by looping through them with `ForEach`. Each item can be clicked to navigate to the edit view.
  - **Delete**: Allows users to swipe and delete todos from the list.
  - **Add Todo**: The "+" button opens a sheet to add a new todo.
  - **Dark Mode**: Toggles between light and dark modes using `AppStorage` to remember the preference across app launches.

### Summary
  - **Main Functionality**: The app allows users to add, edit, and delete todos.
  - **SwiftData Integration**: Data persistence is achieved using SwiftData's `@Model` and `@Query`.
  - **SwiftUI**: The interface uses SwiftUI views like `Form`, `NavigationStack`, and `List` to manage the app's UI efficiently.
  - **Dark Mode**: The app supports dark mode through a simple toggle.





