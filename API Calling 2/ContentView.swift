//
//  ContentView.swift
//  API Calling 2
//
//  Created by Oliver Halvey on 3/7/23.
//

import SwiftUI


struct ContentView: View {
    @State private var entries = [Entry]()
    var body: some View {
        NavigationView {
            List(entries) { entry in
                NavigationLink {
                    VStack {
                        Text(entry.character)
                            .font(.title)
                            .padding()
                        Text(entry.anime)
                            .font(.headline)
                            .padding()
                        Text("\"\(entry.quote)\"")
                            .padding()
                        Spacer()
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(entry.character)
                            .fontWeight(.bold)
                        Text(entry.anime)
                    }
                }
            }
            .navigationTitle("Anime Quotes")
            .toolbar {
                Button {
                    Task {
                        await loadData()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                
            }
        }
        .task {
            await loadData()
        }
    }
    func loadData() async {
        if let url = URL(string: "https://animechan.vercel.app/api/quotes") {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode([Entry].self, from: data) {
                    entries = decodedResponse
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Entry: Identifiable, Codable {
    var id = UUID()
    var anime: String
    var character: String
    var quote: String
    
    enum CodingKeys: String, CodingKey {
    case anime
    case character
    case quote
    }
}
