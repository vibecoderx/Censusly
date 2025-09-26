//
// File: County.swift (NEW)
// Folder: Models
//

import Foundation

/**
 A struct to represent a County, containing its name and FIPS code.
 */
struct County: Identifiable, Codable, Hashable {
    /// The county's FIPS code, used as the unique identifier.
    var id: String { fips }
    
    /// The name of the county (e.g., "Los Angeles County").
    let name: String
    
    /// The FIPS (Federal Information Processing Standards) code for the county.
    let fips: String
}
