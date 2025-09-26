//
// File: SocialData.swift (NEW)
// Folder: Models
//

import Foundation

/**
 A struct that models the key statistics for the "Social" category.
 Each property corresponds to a specific variable from the ACS Data Profile dataset.
 The properties are optional strings because the API may return null or invalid values.
 */
struct SocialData {
    // MARK: - Properties
    let totalHouseholds: String?
    let householdsWithUnder18: String?
    let householdsWithOver65: String?
    let avgHouseholdSize: String?
    let totalFamilies: String?
    let avgFamilySize: String?
    let marriedCoupleFamiliesP: String?
    let schoolEnrolledP: String?
    let highSchoolGradP: String?
    let bachelorsOrHigherP: String?
    let civilianVeteranP: String?
    let foreignBornP: String?
    let speaksOtherLanguageP: String?
    let hasComputerP: String?
    let hasBroadbandP: String?
    let unmarriedWomenBirthsP: String?
    let foreignBornPopP: String?
    let usBornPopP: String?
    let grandparentsResponsibleP: String?
    let naturalizedCitizenP: String?

    // The FIPS code for the state, needed for some geographic queries.
    let stateFips: String?

    /**
     An initializer that maps a raw data array from the Census API into the struct's properties.
     
     - Parameter apiData: An array of strings, where each element corresponds to a variable
       requested from the API. The order is determined by the API call.
     */
    init(apiData: [String]) {
        // The order of assignments must match the order of variables in the API call.
        totalHouseholds = apiData[0]
        householdsWithUnder18 = apiData[1]
        householdsWithOver65 = apiData[2]
        avgHouseholdSize = apiData[3]
        totalFamilies = apiData[4]
        avgFamilySize = apiData[5]
        marriedCoupleFamiliesP = apiData[6]
        schoolEnrolledP = apiData[7]
        highSchoolGradP = apiData[8]
        bachelorsOrHigherP = apiData[9]
        civilianVeteranP = apiData[10]
        foreignBornP = apiData[11]
        speaksOtherLanguageP = apiData[12]
        hasComputerP = apiData[13]
        hasBroadbandP = apiData[14]
        unmarriedWomenBirthsP = apiData[15]
        foreignBornPopP = apiData[16]
        usBornPopP = apiData[17]
        grandparentsResponsibleP = apiData[18]
        naturalizedCitizenP = apiData[19]
        stateFips = apiData[20]
    }
    
    /// A static property to provide empty/placeholder data, useful for previews or initial states.
    static let placeholder = SocialData(apiData: Array(repeating: "...", count: 21))
}
