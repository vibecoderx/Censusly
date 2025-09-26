//
// File: ContentView.swift (MODIFIED)
// Folder: Censusly (Main)
//

import SwiftUI

struct ContentView: View {
    @State private var showingAboutSheet = false

    var body: some View {
        VStack(spacing: 20) {
            // This sets up the main navigation for the app
            NavigationView {
                SelectionView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showingAboutSheet.toggle()
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
            }
            .navigationViewStyle(.stack)
            .sheet(isPresented: $showingAboutSheet) {
                AboutView()
            }
            
            Spacer()
        }
        .padding()
    }
}
 
// MARK: - Xcode Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
