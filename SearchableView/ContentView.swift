//
//  ContentView.swift
//  SearchableView
//
//  Created by George Hargreaves on 24/09/2023.
//

import SwiftUI
import Foundation

struct Subject: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let details: String
}
struct SubjectDetailView: View {
    let subject: Subject
    
    var body: some View {
        Text(subject.details)
            .padding()
            .navigationTitle(subject.name)
    }
}

struct ContentView: View {
    @State private var selectedSubject: Subject?
    @State private var searchText = ""
    @State private var subjects: [Subject] = []
    
    var filteredSubjects: [Subject] {
        if searchText.isEmpty {
            return subjects
        } else {
            return subjects.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredSubjects) { subject in
                NavigationLink(destination: SubjectDetailView(subject: subject)) {
                    Text(subject.name)
                }
            }
            .searchable(text: $searchText)
            .navigationBarTitle("Subjects")
            .onAppear(perform: loadSubjects)
        }
    }
    
    func loadSubjects() {
        if let url = Bundle.main.url(forResource: "subjects", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                subjects = try JSONDecoder().decode([Subject].self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Cannot find subjects.json")
        }
    }
}



#Preview {
    ContentView()
}
