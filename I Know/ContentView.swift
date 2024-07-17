//
//  ContentView.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var persons: [Person]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(persons) { person in
                    Text(person.name)
                }
            }
            .toolbar {
                NavigationLink("Add", destination: AddPerson())
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
