//
//  SuperheroItemView.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 9/3/25.
//

import SwiftUI

struct SuperheroItemView: View {
    let superhero: SuperheroDTO
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(superhero.name)
                    .font(.headline)
                    .bold()
                    .padding()
            }
            Spacer()
            AsyncImage(url: URL(string: superhero.image.url)) { phase in
                switch phase {
                case .empty:
                    HStack {
                        ProgressView()
                    }
                    .frame(width: 100, height: 50)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 50)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    SuperheroItemView(superhero: SuperheroMockRepository.getMockElement())
}
