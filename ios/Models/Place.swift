//
// File: Place.swift (NEW)
// Folder: Models
//

import Foundation


 // A struct to represent a Place (e.g., a city, town, or CDP),
 // containing its name and FIPS code.
 
struct Place: Identifiable, Codable, Hashable {
    /// The place's FIPS code, used as the unique identifier.
    var id: String { fips }
    
    /// The name of the place (e.g., "San Francisco city").
    let name: String
    
    /// The FIPS (Federal Information Processing Standards) code for the place.
    let fips: String
}
