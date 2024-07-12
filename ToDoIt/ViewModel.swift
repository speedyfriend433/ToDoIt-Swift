//
// ViewModel.swift
//
// Created by Speedyfriend67 on 12.07.24
//
 
import Foundation

class ToDoViewModel: ObservableObject {
    @Published var items: [ToDoItem] = [] {
        didSet {
            saveItems()
        }
    }
    
    @Published var searchText = ""

    init() {
        loadItems()
    }

    var filteredItems: [ToDoItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.task.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func addItem(task: String, dueDate: Date? = nil, priority: Priority = .medium) {
        let newItem = ToDoItem(task: task, dueDate: dueDate, priority: priority)
        items.append(newItem)
    }

    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func toggleCompletion(for item: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "todoItems")
        }
    }
    
    func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "todoItems"),
           let decodedItems = try? JSONDecoder().decode([ToDoItem].self, from: savedItems) {
            items = decodedItems
        }
    }
}