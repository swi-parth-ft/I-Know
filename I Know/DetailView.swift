//
//  DetailView.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//

import SwiftUI

struct DetailView: View {
    var person: Person
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: person.photo)!)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Text(person.name)
            Text(person.location)
            Text(formatDate(person.meetDate))
        }
    }
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
    }
}

#Preview {
    DetailView(person: Person(name: "Jon", meetDate: Date.now, location: "Nowhere", photo: UIImage(named: "img")!.jpegData(compressionQuality: 1.0)! ))
}
