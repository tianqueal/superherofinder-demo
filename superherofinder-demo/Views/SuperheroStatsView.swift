//
//  SuperheroStatsView.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 9/3/25.
//

import SwiftUI
import Charts

struct SuperheroStatsView: View {
    let stats: Powerstats
    
    var body: some View {
        VStack {
            let statsData: [(key: String, value: Int?)] = [
                ("Combat", Int(stats.combat)),
                ("Durability", Int(stats.durability)),
                ("Intelligence", Int(stats.intelligence)),
                ("Power", Int(stats.power)),
                ("Speed", Int(stats.speed)),
                ("Strength", Int(stats.strength))
            ]
            
            Chart {
                ForEach(statsData, id: \.key) { stat in
                    if let value = stat.value {
                        SectorMark(angle: .value("Count", value), innerRadius: .ratio(0.6), angularInset: 5)
                            .cornerRadius(10)
                            .foregroundStyle(by: .value("Category", stat.key))
                    }
                }
            }
            .chartLegend(alignment: .center, spacing: 20)
        }
        .padding()
        .cornerRadius(20)
    }
}

#Preview {
    SuperheroStatsView(stats: SuperheroMockRepository.getMockElement().powerstats)
}
