//
// ContentView.swift
//
// Created by Speedyfriend67 on 12.07.24
//
 
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ToDoViewModel()
    @State private var newTask = ""
    @State private var dueDate = Date()
    @State private var priority: Priority = .medium

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new task", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                        .labelsHidden()
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Button(action: {
                        guard !newTask.isEmpty else { return }
                        viewModel.addItem(task: newTask, dueDate: dueDate, priority: priority)
                        newTask = ""
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding()

                SearchBar(text: $viewModel.searchText)

                List {
                    ForEach(viewModel.filteredItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.task)
                                    .strikethrough(item.isCompleted, color: .black)
                                if let dueDate = item.dueDate {
                                    Text("Due: \(dueDate, formatter: DateFormatter.shortDate)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Text("Priority: \(item.priority.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.toggleCompletion(for: item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
            }
            .navigationTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 8)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 8)
                }
            }
        }
        .padding(.horizontal)
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}