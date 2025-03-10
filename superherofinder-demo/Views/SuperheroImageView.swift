//
//  SuperheroImageView.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 9/3/25.
//

import SwiftUI

struct SuperheroImageView: View {
    let imageURL: URL?
    
    var body: some View {
        ZStack {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    PlaceholderView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                        .clipped()
                case .failure:
                    ErrorImageView()
                @unknown default:
                    PlaceholderView()
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    @ViewBuilder
    private func PlaceholderView() -> some View {
        ZStack {
            Color.gray.opacity(0.3)
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
    }
    
    @ViewBuilder
    private func ErrorImageView() -> some View {
        ZStack {
            Color.red.opacity(0.1)
            Image(systemName: "photo.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
    }
}

#Preview {
    SuperheroImageView(imageURL:URL(string: SuperheroMockRepository.getMockElement().image.url))
}
