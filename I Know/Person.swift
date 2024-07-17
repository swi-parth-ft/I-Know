//
//  Person.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class Person: Identifiable {
    let id = UUID()
    let name: String
    let meetDate: Date
    let location: String
    let photo: Data
    
    init(name: String, meetDate: Date, location: String, photo: Data) {
        self.name = name
        self.meetDate = meetDate
        self.location = location
        self.photo = photo
    }
}
