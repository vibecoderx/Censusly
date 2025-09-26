//
// File: EconomicData.swift (NEW)
// Folder: Models
//

import Foundation

/**
 A struct that models the key statistics for the "Economic" category.
 Each property corresponds to a specific variable from the ACS Data Profile dataset.
 The properties are optional strings because the API may return null or invalid values.
 */
struct EconomicData {
    // MARK: - Properties
    let inLaborForceP: String?
    let unemploymentRateP: String?
    let meanTravelTime: String?
    let managementOccupationsP: String?
    let constructionOccupationsP: String?
    let privateWorkersP: String?
    let governmentWorkersP: String?
    let meanIncome: String?
    let medianHouseholdIncome: String?
    let meanHouseholdIncome: String?
    let withSocialSecurityP: String?
    let withSnapP: String?
    let withHealthInsuranceP: String?
    let withPrivateHealthInsuranceP: String?
    let withPublicCoverageP: String?
    let belowPovertyLevelP: String?
    let droveAloneP: String?
    let carpooledP: String?
    let publicTransportationP: String?
    let perCapitaIncome: String?

    // The FIPS code for the state, needed for some geographic queries.
    let stateFips: String?

    /**
     An initializer that maps a raw data array from the Census API into the struct's properties.
     
     - Parameter apiData: An array of strings, where each element corresponds to a variable
       requested from the API. The order is determined by the API call.
     */
    init(apiData: [String]) {
        // The order of assignments must match the order of variables in the API call.
        inLaborForceP = apiData[0]
        unemploymentRateP = apiData[1]
        meanTravelTime = apiData[2]
        managementOccupationsP = apiData[3]
        constructionOccupationsP = apiData[4]
        privateWorkersP = apiData[5]
        governmentWorkersP = apiData[6]
        meanIncome = apiData[7]
        medianHouseholdIncome = apiData[8]
        meanHouseholdIncome = apiData[9]
        withSocialSecurityP = apiData[10]
        withSnapP = apiData[11]
        withHealthInsuranceP = apiData[12]
        withPrivateHealthInsuranceP = apiData[13]
        withPublicCoverageP = apiData[14]
        belowPovertyLevelP = apiData[15]
        droveAloneP = apiData[16]
        carpooledP = apiData[17]
        publicTransportationP = apiData[18]
        perCapitaIncome = apiData[19]
        stateFips = apiData[20]
    }
    
    /// A static property to provide empty/placeholder data, useful for previews or initial states.
    static let placeholder = EconomicData(apiData: Array(repeating: "...", count: 21))
}
