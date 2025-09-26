//
// File: CategorySelectionView.swift (MODIFIED)
//

import SwiftUI

struct CategorySelectionView: View {
    // FIX: The location property is updated to expect the new tuple
    // that includes the FIPS code for the selected geography.
    let location: (level: SelectionView.GeoLevel, name: String, fips: String)
    let stateFips: String

    private var displayLocation: String {
        // The display logic remains the same, just accessing the name from the new tuple.
        return location.name
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Category for")
                .font(.title2)
            Text(displayLocation)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            // Each NavigationLink now correctly passes the updated location tuple.
            NavigationLink(destination: DataDisplayView(location: location, stateFips: stateFips, category: "Overview")) {
                categoryButton(title: "Overview")
            }
            NavigationLink(destination: DataDisplayView(location: location, stateFips: stateFips, category: "Demographic")) {
                categoryButton(title: "Demographic")
            }
            NavigationLink(destination: DataDisplayView(location: location, stateFips: stateFips, category: "Social")) {
                categoryButton(title: "Social")
            }
            NavigationLink(destination: DataDisplayView(location: location, stateFips: stateFips, category: "Economic")) {
                categoryButton(title: "Economic")
            }
            NavigationLink(destination: DataDisplayView(location: location, stateFips: stateFips, category: "Housing")) {
                categoryButton(title: "Housing")
            }
            
            Spacer()
            Spacer()
        }
        .padding()
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func categoryButton(title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
    }
}
