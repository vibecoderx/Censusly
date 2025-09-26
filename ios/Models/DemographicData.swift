//
// File: DemographicData.swift (NEW)
// Folder: Models
//

import Foundation

/**
 A struct that models the key statistics for the "Demographic" category.
 Each property corresponds to a specific variable from the ACS Data Profile dataset.
 The properties are optional strings because the API may return null or invalid values.
 */
struct DemographicData {
    // MARK: - Properties
    let totalPopulation: String?
    let malePopulation: String?
    let femalePopulation: String?
    let medianAge: String?
    let under18: String?
    let over65: String?
    let whiteP: String?
    let blackP: String?
    let nativeP: String?
    let asianP: String?
    let pacificP: String?
    let otherP: String?
    let twoOrMoreP: String?
    let hispanicP: String?
    let whiteNonHispP: String?
    let totalHousing: String?
    let citizen18AndOverP: String?
    let pop21AndOver: String?
    let pop18AndOver: String?
    let sexRatio: String?

    // The FIPS code for the state, needed for some geographic queries.
    let stateFips: String?

    /**
     An initializer that maps a raw data array from the Census API into the struct's properties.
     
     - Parameter apiData: An array of strings, where each element corresponds to a variable
       requested from the API. The order is determined by the API call.
     */
    init(apiData: [String]) {
        // The order of assignments must match the order of variables in the API call.
        totalPopulation = apiData[0]
        malePopulation = apiData[1]
        femalePopulation = apiData[2]
        medianAge = apiData[3]
        under18 = apiData[4]
        over65 = apiData[5]
        whiteP = apiData[6]
        blackP = apiData[7]
        nativeP = apiData[8]
        asianP = apiData[9]
        pacificP = apiData[10]
        otherP = apiData[11]
        twoOrMoreP = apiData[12]
        hispanicP = apiData[13]
        whiteNonHispP = apiData[14]
        totalHousing = apiData[15]
        citizen18AndOverP = apiData[16]
        pop21AndOver = apiData[17]
        pop18AndOver = apiData[18]
        sexRatio = apiData[19]
        stateFips = apiData[20]
    }
    
    /// A static property to provide empty/placeholder data, useful for previews or initial states.
    static let placeholder = DemographicData(apiData: Array(repeating: "...", count: 21))
}
