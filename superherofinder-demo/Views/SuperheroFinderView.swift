//
//  SuperheroFinderView.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 8/3/25.
//

import SwiftUI

struct SuperheroFinderView: View {
    @State var searchText = ""
    @State var repository: SuperheroDataRepository = SuperheroAPIRepository()
    @State var superheroes: [SuperheroDTO] = []
    @State var loading = false
    @State var hasSearched = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(superheroes) { superhero in
                    NavigationLink(destination: SuperheroDetailView(tmpSuperheroData: superhero)) {
                        SuperheroItemView(superhero: superhero)
                    }
                }
                .searchable(text: $searchText, prompt: "Find a superhero...")
                .autocorrectionDisabled()
                
#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
                .textInputAutocapitalization(.never)
#endif
                .onSubmit(of: .search) {
                    performSearch()
                }
#if os(iOS)
                .listStyle(.plain)
#endif
                if searchText.isEmpty && !hasSearched {
                    VStack {
                        Image(systemName: "sparkles.rectangle.stack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.blue)
                            .opacity(0.8)
                        Text("Discover Superheroes")
                            .font(.title2)
                            .bold()
                        Text("Type a name in the search box above to find your favorite superhero.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                
                if loading {
                    VStack {
                        Spacer()
                        ProgressView("Searching...")
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if !loading && !searchText.isEmpty && superheroes.isEmpty && hasSearched {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .opacity(0.8)
                        Text("No Results for \"\(searchText)\"")
                            .font(.title2)
                            .bold()
                        Text("Search for a different name or try again later.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .navigationTitle("Superhero Finder")
        }
    }
    
    private func performSearch() {
        Task {
            loading = true
            
            if !hasSearched {
                hasSearched.toggle()
            }
            
            do {
                superheroes = try await repository.searchByName(searchText)
            } catch {
                print("Error: \(error)")
            }
            loading = false
        }
    }
}

#Preview {
    SuperheroFinderView(repository: SuperheroLocalRepository())
}
