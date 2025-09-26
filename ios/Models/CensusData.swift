//
// File: CensusData.swift (MODIFIED)
// Folder: Models
//

import Foundation

// A simplified data model for the ACS data
struct CensusData: Identifiable {
    let id = UUID()
    var period: String // e.g., "2018-2022"
    var locationName: String = "N/A"
    var totalPopulation: Int = 0
    var medianAge: Double = 0.0
    var medianIncome: Double = 0.0
    // More properties would be added here
}
