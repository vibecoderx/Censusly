//
// File: StateAbbreviationHelper.swift (NEW)
// Folder: Helpers
//

import Foundation

// A helper struct to provide a mapping from full state names to their two-letter abbreviations.
// This is necessary because the Census API returns full names (e.g., "New York"), but we want to
// display the standard abbreviations (e.g., "NY").

struct StateAbbreviationHelper {
    
    /// A static dictionary that holds the mapping.
    static private let nameToAbbreviation = [
        "Alabama": "AL", "Alaska": "AK", "Arizona": "AZ", "Arkansas": "AR",
        "California": "CA", "Colorado": "CO", "Connecticut": "CT", "Delaware": "DE",
        "Florida": "FL", "Georgia": "GA", "Hawaii": "HI", "Idaho": "ID",
        "Illinois": "IL", "Indiana": "IN", "Iowa": "IA", "Kansas": "KS",
        "Kentucky": "KY", "Louisiana": "LA", "Maine": "ME", "Maryland": "MD",
        "Massachusetts": "MA", "Michigan": "MI", "Minnesota": "MN", "Mississippi": "MS",
        "Missouri": "MO", "Montana": "MT", "Nebraska": "NE", "Nevada": "NV",
        "New Hampshire": "NH", "New Jersey": "NJ", "New Mexico": "NM", "New York": "NY",
        "North Carolina": "NC", "North Dakota": "ND", "Ohio": "OH", "Oklahoma": "OK",
        "Oregon": "OR", "Pennsylvania": "PA", "Rhode Island": "RI", "South Carolina": "SC",
        "South Dakota": "SD", "Tennessee": "TN", "Texas": "TX", "Utah": "UT",
        "Vermont": "VT", "Virginia": "VA", "Washington": "WA", "West Virginia": "WV",
        "Wisconsin": "WI", "Wyoming": "WY", "District of Columbia": "DC", "Puerto Rico": "PR"
    ]

    
//     Returns the two-letter abbreviation for a given full state name.
//     
//     - Parameter name: The full name of the state (e.g., "California").
//     - Returns: An optional string containing the two-letter abbreviation (e.g., "CA"), or nil if not found.

    static func abbreviation(for name: String) -> String? {
        return nameToAbbreviation[name]
    }
}
