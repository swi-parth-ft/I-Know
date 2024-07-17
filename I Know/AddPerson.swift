//
//  AddPerson.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//
import SwiftData
import SwiftUI
import PhotosUI
import CoreLocation

struct AddPerson: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var location: String?
    @State private var image: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data? = nil
    @State private var defaultImageData: Data = UIImage(named: "img")!.jpegData(compressionQuality: 1.0)!
    @State private var cityName: String = "Unknown City"
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        Form {
            PhotosPicker(selection: $selectedItem) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(22)
                        .frame(maxWidth: .infinity) // Center the image horizontally
                        .padding(.top, 10)
                        .shadow(radius: 5)
                    
                } else {
                    ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                        .frame(maxWidth: .infinity)
                }
            }
            TextField("Name", text: $name)
          //  TextField("Location", text: $location)
            
           
            
            Button(cityName == "Unknown City" ? "Add Location" : cityName) {
                if let loc = locationFetcher.lastKnownLocation {
                    location = "\(loc.latitude), \(loc.longitude)"
                                    print("Your location is \(loc)")
                    getCityName(from: loc)
                                } else {
                                    print("Your location is unknown")
                                }
                
                
            }
            Button("Save") {
                Task {
                    await loadImage()
                    
                    
                    let person = Person(name: name, meetDate: Date.now, location: location ?? "N/A", photo: selectedImageData ?? defaultImageData, city: cityName)
                    modelContext.insert(person)
                    dismiss()
                }
            
                
                
            }
        }
        .onChange(of: selectedItem) {
            Task {
                await loadImage()
            }
        }
        .onAppear {
            locationFetcher.start()
                    }
    }
    
    func loadImage() async {
        
        
        do {
            if let imageData = try await selectedItem?.loadTransferable(type: Data.self) {
                selectedImageData = imageData
                if let uiImage = UIImage(data: imageData) {
                    image = Image(uiImage: uiImage)
                }
            } else {
                selectedImageData = defaultImageData
                image = Image(uiImage: UIImage(data: defaultImageData)!)
            }
        } catch {
            print("Failed to load image data: \(error.localizedDescription)")
            selectedImageData = defaultImageData
            image = Image(uiImage: UIImage(data: defaultImageData)!)
        }
    }
    
    func getCityName(from coordinate: CLLocationCoordinate2D) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self.cityName = city
                    } else {
                        self.cityName = "City not found"
                    }
                } else {
                    print("Failed to get city name: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    
   
    
}

#Preview {
    AddPerson()
}
