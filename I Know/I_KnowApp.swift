//
//  I_KnowApp.swift
//  I Know
//
//  Created by Parth Antala on 2024-07-17.
//
import SwiftData
import SwiftUI

@main
struct I_KnowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
