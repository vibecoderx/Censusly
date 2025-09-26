//
// File: HousingData.swift (NEW)
// Folder: Models
//

import Foundation

/**
 A struct that models the key statistics for the "Housing" category.
 Each property corresponds to a specific variable from the ACS Data Profile dataset.
 The properties are optional strings because the API may return null or invalid values.
 */
struct HousingData {
    // MARK: - Properties
    let totalHousingUnits: String?
    let occupiedHousingUnitsP: String?
    let vacantHousingUnitsP: String?
    let ownerOccupiedP: String?
    let renterOccupiedP: String?
    let avgHouseholdSizeOwner: String?
    let avgHouseholdSizeRenter: String?
    let oneUnitDetachedP: String?
    let tenOrMoreUnitsP: String?
    let built2014OrLaterP: String?
    let threeBedroomsP: String?
    let occupantsPerRoom1_01OrMoreP: String?
    let medianValue: String?
    let withMortgageP: String?
    let medianMonthlyOwnerCostsWithMortgage: String?
    let medianMonthlyOwnerCostsWithoutMortgage: String?
    let medianGrossRent: String?
    let grossRent35PercentOrMoreP: String?
    let noVehiclesP: String?
    let utilityGasP: String?

    // The FIPS code for the state, needed for some geographic queries.
    let stateFips: String?

    /**
     An initializer that maps a raw data array from the Census API into the struct's properties.
     
     - Parameter apiData: An array of strings, where each element corresponds to a variable
       requested from the API. The order is determined by the API call.
     */
    init(apiData: [String]) {
        // The order of assignments must match the order of variables in the API call.
        totalHousingUnits = apiData[0]
        occupiedHousingUnitsP = apiData[1]
        vacantHousingUnitsP = apiData[2]
        ownerOccupiedP = apiData[3]
        renterOccupiedP = apiData[4]
        avgHouseholdSizeOwner = apiData[5]
        avgHouseholdSizeRenter = apiData[6]
        oneUnitDetachedP = apiData[7]
        tenOrMoreUnitsP = apiData[8]
        built2014OrLaterP = apiData[9]
        threeBedroomsP = apiData[10]
        occupantsPerRoom1_01OrMoreP = apiData[11]
        medianValue = apiData[12]
        withMortgageP = apiData[13]
        medianMonthlyOwnerCostsWithMortgage = apiData[14]
        medianMonthlyOwnerCostsWithoutMortgage = apiData[15]
        medianGrossRent = apiData[16]
        grossRent35PercentOrMoreP = apiData[17]
        noVehiclesP = apiData[18]
        utilityGasP = apiData[19]
        stateFips = apiData[20]
    }
    
    /// A static property to provide empty/placeholder data, useful for previews or initial states.
    static let placeholder = HousingData(apiData: Array(repeating: "...", count: 21))
}
