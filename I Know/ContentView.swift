//
//  ContentView.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//
import SwiftData
import SwiftUI

enum SortOption {
    case name
    case meetDate
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var sortOrder: SortOption = .meetDate
    @Query var persons: [Person]
    
    @State private var selectedPerson: Person? = nil
    @State private var isDetailViewPresented: Bool = false
    
    private var sortedPersons: [Person] {
        switch sortOrder {
        case .name:
            return persons.sorted { $0.name < $1.name }
        case .meetDate:
            return persons.sorted { $0.meetDate < $1.meetDate }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedPersons) { person in
                    Button(action: {
                        selectedPerson = person
                        isDetailViewPresented = true
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(person.name)
                                    .font(.headline)
                                Text(person.location)
                                    .font(.subheadline)
                            }
                            Spacer()
                            if let uiImage = UIImage(data: person.photo) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .tint(.primary)
                }
                .onDelete(perform: deletePerson)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort By", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag(SortOption.name)
                            
                            Text("Sort by join date")
                                .tag(SortOption.meetDate)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AddPerson()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Persons")
            .sheet(isPresented: $isDetailViewPresented) {
                if let selectedPerson = selectedPerson {
                    DetailView(person: selectedPerson)
                        .presentationDetents([.fraction(0.7), .medium, .large])
                }
            }
        }
    }
    
    func deletePerson(at offsets: IndexSet) {
        for index in offsets {
            let person = persons[index]
            modelContext.delete(person)
        }
    }
}


#Preview {
    ContentView()
}
