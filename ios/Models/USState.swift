//
// File: USState.swift (NEW)
// Folder: Models
//

import Foundation
//
// A struct to represent a US State, using the name `USState` to avoid
// conflicts with SwiftUI's `@State` property wrapper.
// 
struct USState: Identifiable, Codable, Hashable {
    /// The state's FIPS code, used as the unique identifier.
    var id: String { fips }
    
    /// The two-letter abbreviation of the state (e.g., "NY", "CA").
    let name: String
    
    /// The FIPS (Federal Information Processing Standards) code for the state.
    let fips: String
}
