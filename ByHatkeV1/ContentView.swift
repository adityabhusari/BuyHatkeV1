//
//  ContentView.swift
//  ByHatkeV1
//
//  Created by Chinmay Patil on 10/4/24.
//

import SwiftUI
import SwiftData

@Model
class Todo: Identifiable, Equatable {
    @Attribute(.unique) var id = UUID()
    var title: String
    var desc: String
    var isComplete: Bool
    var dt: Date
    
    init(id: UUID = UUID(), title: String, desc: String, isComplete: Bool, dt: Date) {
        self.id = id
        self.title = title
        self.desc = desc
        self.isComplete = isComplete
        self.dt = dt
    }
    
}

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

struct EditTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var todo: Todo
    let editAction: (Todo) -> ()
    var body: some View {
        Form {
            HStack {
                Text("Created on")
                Spacer()
                Text(todo.dt, style: .date)
                Text("at")
                Text(todo.dt, style: .time)
            }
            Toggle("Completed", isOn: $todo.isComplete)
            Section("Title") {
                TextField("", text: $todo.title)
            }
            Section("Description") {
                TextField("", text: $todo.desc, axis: .vertical)
                    .lineLimit(5...10)
            }
        }
        .navigationTitle("Edit")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    editAction(todo)
                    dismiss()
                } label: {
                    Text("Submit")
                }
                .disabled(todo.title.isEmpty)
            }
        }
    }
}

struct NewTodoView: View {
    @Environment(\.dismiss) var dismiss
    @State var titleText = ""
    @State var descText = ""
    
    let addAction: (Todo) -> ()
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $titleText)
                Section("Description") {
                    TextField("", text: $descText, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("Add Todo")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addAction(Todo(title: titleText, desc: descText, isComplete: false, dt: .now))
                        dismiss()
                    } label: {
                        Text("Submit")
                    }
                    .disabled(titleText.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var todos: [Todo]
    
    @State var isShowingSheet = false
    @AppStorage("isDarkMode") private var isDarkMode = false

    
    func addTodo(todo: Todo) {
        withAnimation { context.insert(todo) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    NavigationLink {
                        EditTodoView(todo: todo, editAction: addTodo)
                    } label: {
                        TodoTile(todo: todo, editAction: addTodo)
                    }
                }
                .onDelete { idx in
                    for i in idx {
                        context.delete(todos[i])
                    }
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                NewTodoView(addAction: addTodo)
            }
        }
    }
}
