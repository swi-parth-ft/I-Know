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
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
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
