//
//  ByHatkeV1Tests.swift
//  ByHatkeV1Tests
//
//  Created by Chinmay Patil on 10/4/24.
//

import XCTest
import SwiftUI
@testable import ByHatkeV1

class TodoTests: XCTestCase {
    
    func testTodoInitialization() {
        let todo = Todo(title: "Test Todo", desc: "Test Description", isComplete: false, dt: Date())
        
        XCTAssertNotNil(todo.id)
        XCTAssertEqual(todo.title, "Test Todo")
        XCTAssertEqual(todo.desc, "Test Description")
        XCTAssertFalse(todo.isComplete)
        XCTAssertNotNil(todo.dt)
    }
    
    func testTodoEquality() {
        let id = UUID()
        let date = Date()
        let todo1 = Todo(id: id, title: "Test", desc: "Desc", isComplete: true, dt: date)
        let todo2 = Todo(id: id, title: "Test", desc: "Desc", isComplete: true, dt: date)
        
        XCTAssertEqual(todo1, todo2)
    }
}
