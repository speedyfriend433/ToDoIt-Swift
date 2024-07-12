//
// ToDoItem.swift
//
// Created by Speedyfriend67 on 12.07.24
//
 
import Foundation

enum Priority: String, Codable, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var task: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority = .medium
}