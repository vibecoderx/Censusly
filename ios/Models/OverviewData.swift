//
// File: OverviewData.swift (MODIFIED)
// Folder: Models
//

import Foundation

/**
 A struct that models the key statistics for the "Overview" category.
 Each property corresponds to a specific variable from the ACS Data Profile dataset.
 The properties are optional strings because the API may return null or invalid values.
 */
struct OverviewData {
    // MARK: - Properties
    let totalPopulation: String?
    let medianAge: String?
    let medianIncome: String?
    let highSchoolGradP: String?
    let povertyP: String?
    let ownerOccupiedP: String?
    let avgCommuteTime: String?
    let medianHomeValue: String?
    let unemploymentP: String?
    
    // FIX: Added 5 new properties for the Overview category.
    let foreignBorn: String?
    let veterans: String?
    let householdsWithComputerP: String?
    let bachelorsOrHigherP: String?
    let medianGrossRent: String?
    
    // The FIPS code for the state, needed for some geographic queries.
    let stateFips: String?

    /**
     An initializer that maps a raw data array from the Census API into the struct's properties.
     
     - Parameter apiData: An array of strings, where each element corresponds to a variable
       requested from the API. The order is determined by the API call.
     */
    init(apiData: [String]) {
        // FIX: Updated the initializer to map the additional data points.
        // The order of assignments must match the order of variables in the API call.
        totalPopulation = apiData[0]
        medianAge = apiData[1]
        medianIncome = apiData[2]
        highSchoolGradP = apiData[3]
        povertyP = apiData[4]
        ownerOccupiedP = apiData[5]
        avgCommuteTime = apiData[6]
        medianHomeValue = apiData[7]
        unemploymentP = apiData[8]
        
        foreignBorn = apiData[9]
        veterans = apiData[10]
        householdsWithComputerP = apiData[11]
        bachelorsOrHigherP = apiData[12]
        medianGrossRent = apiData[13]
        
        stateFips = apiData[14]
    }
    
    /// A static property to provide empty/placeholder data, useful for previews or initial states.
    static let placeholder = OverviewData(apiData: Array(repeating: "...", count: 15))
}
