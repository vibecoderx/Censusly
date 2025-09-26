//
// File: ChartView.swift
// Folder: Helpers
//

import SwiftUI

// A placeholder for a generic chart view
struct ChartView: View {
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            
            // In a real app, this would be a bar chart, pie chart, etc.
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(Text("Chart Placeholder"))
        }
    }
}
