//
//  AddPerson.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//
import SwiftData
import SwiftUI
import PhotosUI

struct AddPerson: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var image: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data? = nil
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Location", text: $location)
            PhotosPicker(selection: $selectedItem) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }
            Button("Save") {
                loadImage()
                
            }
        }
        .onChange(of: selectedItem, loadImage)
    }
    
    func loadImage() {
        Task {
            if let imageData = try await selectedItem?.loadTransferable(type: Data.self) {
                selectedImageData = imageData
            }else { return }

        }
        
        let person = Person(name: name, meetDate: Date.now, location: location, photo: selectedImageData)
        
        modelContext.insert(person)
        dismiss()
    }
}

#Preview {
    AddPerson()
}
