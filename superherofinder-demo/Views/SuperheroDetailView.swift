//
//  SuperheroDetailView.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 8/3/25.
//

import SwiftUI

struct SuperheroDetailView: View {
    let tmpSuperheroData: SuperheroDTO
    @State var repository: SuperheroDataRepository = SuperheroAPIRepository()
    @State var superhero: SuperheroDTO? = nil
    @State var loading: Bool = false
    
    var body: some View {
        VStack {
            if loading {
                VStack {
                    Spacer()
                    ProgressView("Loading superhero...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                
            } else if let superhero = superhero {
                VStack(spacing: 20) {
                    SuperheroImageView(imageURL: URL(string: superhero.image.url))
                    Text(superhero.biography.aliases.joined(separator: ", ")).italic().multilineTextAlignment(.center)
                    SuperheroStatsView(stats: superhero.powerstats)
                }
            }
        }
        .navigationTitle(tmpSuperheroData.name)
        .onAppear() {
            Task {
                loading = true
                do {
                    superhero = try await repository.getById(tmpSuperheroData.id)
                } catch {
                    print("Error loading superhero: \(error)")
                }
                loading = false
            }
        }
    }
}

#Preview {
    SuperheroDetailView(tmpSuperheroData: SuperheroMockRepository.getMockElement(), repository: SuperheroLocalRepository())
}
