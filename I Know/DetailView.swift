//
//  DetailView.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//

import SwiftUI
import MapKit

struct DetailView: View {
    var person: Person
    @State private var region: MKCoordinateRegion
    @State private var coordinate: Coordinate?
    @State private var cityName: String = "Unknown City"
    @State private var currentPage = 0
    struct Coordinate: Identifiable {
        let id = UUID()
        let location: CLLocationCoordinate2D
    }

    init(person: Person) {
        self.person = person
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                
                Text(formatDate(person.meetDate))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(cityName)
                    .font(.subheadline)
                    .underline()
                    .foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation {
                            currentPage = 1
                        }
                    }
            }
            .padding(.leading, 25)
            
            TabView(selection: $currentPage) {
                Image(uiImage: UIImage(data: person.photo)!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(22)
                    .frame(height: 350)
                    .frame(maxWidth: .infinity)
                    .shadow(radius: 10)
                    .padding()
                    .tag(0)
                
                
                if let coordinate = coordinate {
                    Map(coordinateRegion: $region, interactionModes: [] ,annotationItems: [coordinate]) { location in
                        MapAnnotation(coordinate: location.location) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                    .frame(height: 350)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .onAppear {
                        setRegion(for: person.location)
                    }
                    .padding()
                    .shadow(radius: 10)
                    .tag(1)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            setRegion(for: person.location)
                        }
                        .shadow(radius: 10)
                        .tag(1)
                }
                
                
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: UIScreen.main.bounds.height * 0.45)
        }
       
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func setRegion(for location: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let placemark = placemarks?.first,
               let coordinate = placemark.location?.coordinate {
                self.coordinate = Coordinate(location: coordinate)
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                getCityName(from: coordinate)
                
            } else {
                print("Failed to get location coordinates: \(error?.localizedDescription ?? "Unknown error")")
            }
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
    DetailView(person: Person(name: "Jon", meetDate: Date.now, location: "New York, NY", photo: UIImage(named: "img")!.jpegData(compressionQuality: 1.0)!, city: "New York, NY" ))
}
