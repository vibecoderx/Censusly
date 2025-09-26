//
// File: VisualsView.swift (MODIFIED)
// Folder: Views/Visualizations
//

import SwiftUI

struct VisualsView: View {
    let primaryLocationName: String
    let comparisonLocationName: String?
    
    let overviewData: OverviewData?
    let historicalOverviewData: [String: OverviewData]
    let comparisonOverviewData: OverviewData?
    let historicalComparisonOverviewData: [String: OverviewData]
    
    let demographicData: DemographicData?
    let historicalDemographicData: [String: DemographicData]
    let comparisonDemographicData: DemographicData?
    let historicalComparisonDemographicData: [String: DemographicData]
    
    let socialData: SocialData?
    let historicalSocialData: [String: SocialData]
    let comparisonSocialData: SocialData?
    let historicalComparisonSocialData: [String: SocialData]
    
    let economicData: EconomicData?
    let historicalEconomicData: [String: EconomicData]
    let comparisonEconomicData: EconomicData?
    let historicalComparisonEconomicData: [String: EconomicData]
    
    let housingData: HousingData?
    let historicalHousingData: [String: HousingData]
    let comparisonHousingData: HousingData?
    let historicalComparisonHousingData: [String: HousingData]
    
    let category: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Visualizations for \(category)")
                    .font(.title2).fontWeight(.bold)
                
                if let comparisonName = comparisonLocationName {
                    HStack {
                        Circle().fill(.blue).frame(width: 10, height: 10)
                        Text(primaryLocationName)
                        Circle().fill(.green).frame(width: 10, height: 10).padding(.leading)
                        Text(comparisonName)
                    }
                    .font(.caption).foregroundColor(.secondary)
                }
                
                LazyVStack(spacing: 20) {
                    switch category {
                    case "Demographic":
                        demographicCards
                    case "Social":
                        socialCards
                    case "Economic":
                        economicCards
                    case "Housing":
                        housingCards
                    default:
                        overviewCards
                    }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var overviewCards: some View {
        if let data = overviewData {
            VisualizationCard(
                title: "Total Population",
                latestValue: data.totalPopulation,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.totalPopulation,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.totalPopulation,
                format: .number
            )
            VisualizationCard(
                title: "Median Age",
                latestValue: data.medianAge,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.medianAge,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.medianAge,
                format: .none
            )
            VisualizationCard(
                title: "Median Income",
                latestValue: data.medianIncome,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.medianIncome,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.medianIncome,
                format: .currency
            )
            VisualizationCard(
                title: "High School Grad+",
                latestValue: data.highSchoolGradP,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.highSchoolGradP,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.highSchoolGradP,
                format: .percent
            )
            VisualizationCard(
                title: "Poverty Rate",
                latestValue: data.povertyP,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.povertyP,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.povertyP,
                format: .percent
            )
            VisualizationCard(
                title: "Owner-Occupied",
                latestValue: data.ownerOccupiedP,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.ownerOccupiedP,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.ownerOccupiedP,
                format: .percent
            )
            VisualizationCard(
                title: "Average Commute Time",
                latestValue: data.avgCommuteTime,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.avgCommuteTime,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.avgCommuteTime,
                format: .none
            )
            VisualizationCard(
                title: "Median Home Value",
                latestValue: data.medianHomeValue,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.medianHomeValue,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.medianHomeValue,
                format: .currency
            )
            VisualizationCard(
                title: "Unemployment Rate",
                latestValue: data.unemploymentP,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.unemploymentP,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.unemploymentP,
                format: .percent
            )
            
            // FIX: Added 5 new VisualizationCard views for the new overview fields.
            VisualizationCard(
                title: "Foreign-Born Population",
                latestValue: data.foreignBorn,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.foreignBorn,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.foreignBorn,
                format: .number
            )
            VisualizationCard(
                title: "Veteran Population",
                latestValue: data.veterans,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.veterans,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.veterans,
                format: .number
            )
            VisualizationCard(
                title: "Households with a Computer",
                latestValue: data.householdsWithComputerP,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.householdsWithComputerP,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.householdsWithComputerP,
                format: .percent
            )
            VisualizationCard(
                title: "Bachelor's Degree or Higher",
                latestValue: data.bachelorsOrHigherP,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.bachelorsOrHigherP,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.bachelorsOrHigherP,
                format: .percent
            )
            VisualizationCard(
                title: "Median Gross Rent",
                latestValue: data.medianGrossRent,
                historicalData: historicalOverviewData.mapValues { $0 as Any },
                latestComparisonValue: comparisonOverviewData?.medianGrossRent,
                historicalComparisonData: historicalComparisonOverviewData.mapValues { $0 as Any },
                keyPath: \OverviewData.medianGrossRent,
                format: .currency
            )
        }
    }
    
    @ViewBuilder
    private var demographicCards: some View {
        if let data = demographicData {
            VisualizationCard(
                title: "Total Population",
                latestValue: data.totalPopulation,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.totalPopulation,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.totalPopulation,
                format: .number
            )
            VisualizationCard(
                title: "Male Population",
                latestValue: data.malePopulation,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.malePopulation,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.malePopulation,
                format: .number
            )
            VisualizationCard(
                title: "Female Population",
                latestValue: data.femalePopulation,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.femalePopulation,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.femalePopulation,
                format: .number
            )
            VisualizationCard(
                title: "Median Age",
                latestValue: data.medianAge,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.medianAge,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.medianAge,
                format: .none
            )
            VisualizationCard(
                title: "Population Under 18",
                latestValue: data.under18,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.under18,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.under18,
                format: .number
            )
            VisualizationCard(
                title: "Population 65+",
                latestValue: data.over65,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.over65,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.over65,
                format: .number
            )
            VisualizationCard(
                title: "White",
                latestValue: data.whiteP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.whiteP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.whiteP,
                format: .percent
            )
            VisualizationCard(
                title: "Black",
                latestValue: data.blackP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.blackP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.blackP,
                format: .percent
            )
            VisualizationCard(
                title: "Native American/Alaska",
                latestValue: data.nativeP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.nativeP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.nativeP,
                format: .percent
            )
            VisualizationCard(
                title: "Asian",
                latestValue: data.asianP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.asianP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.asianP,
                format: .percent
            )
            VisualizationCard(
                title: "Pacific Islander",
                latestValue: data.pacificP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.pacificP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.pacificP,
                format: .percent
            )
            VisualizationCard(
                title: "One Race",
                latestValue: data.otherP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.otherP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.otherP,
                format: .percent
            )
            VisualizationCard(
                title: "Two or More Races",
                latestValue: data.twoOrMoreP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.twoOrMoreP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.twoOrMoreP,
                format: .percent
            )
            VisualizationCard(
                title: "Hispanic",
                latestValue: data.hispanicP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.hispanicP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.hispanicP,
                format: .percent
            )
            VisualizationCard(
                title: "White (Non-Hispanic)",
                latestValue: data.whiteNonHispP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.whiteNonHispP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.whiteNonHispP,
                format: .percent
            )
            VisualizationCard(
                title: "Sex Ratio (M / 100 F)",
                latestValue: data.totalHousing,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.totalHousing,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.totalHousing,
                format: .number
            )
            VisualizationCard(
                title: "Born in USA",
                latestValue: data.citizen18AndOverP,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.citizen18AndOverP,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.citizen18AndOverP,
                format: .percent
            )
            VisualizationCard(
                title: "Population 21+",
                latestValue: data.pop21AndOver,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.pop21AndOver,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.pop21AndOver,
                format: .percent
            )
            VisualizationCard(
                title: "Population 18+",
                latestValue: data.pop18AndOver,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.pop18AndOver,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.pop18AndOver,
                format: .percent
            )
            VisualizationCard(
                title: "English-language only households",
                latestValue: data.sexRatio,
                historicalData: historicalDemographicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonDemographicData?.sexRatio,
                historicalComparisonData: historicalComparisonDemographicData.mapValues { $0 as Any },
                keyPath: \DemographicData.sexRatio,
                format: .percent
            )
        }
    }
    
    @ViewBuilder
    private var socialCards: some View {
        if let data = socialData {
            VisualizationCard(
                title: "Total Households",
                latestValue: data.totalHouseholds,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.totalHouseholds,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.totalHouseholds,
                format: .number
            )
            VisualizationCard(
                title: "Households with <18",
                latestValue: data.householdsWithUnder18,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.householdsWithUnder18,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.householdsWithUnder18,
                format: .percent
            )
            VisualizationCard(
                title: "Households with 65+",
                latestValue: data.householdsWithOver65,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.householdsWithOver65,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.householdsWithOver65,
                format: .percent
            )
            VisualizationCard(
                title: "Avg. Household Size",
                latestValue: data.avgHouseholdSize,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.avgHouseholdSize,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.avgHouseholdSize,
                format: .number
            )
            VisualizationCard(
                title: "Cohabiting couple household",
                latestValue: data.totalFamilies,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.totalFamilies,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.totalFamilies,
                format: .percent
            )
            VisualizationCard(
                title: "Avg. Family Size",
                latestValue: data.avgFamilySize,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.avgFamilySize,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.avgFamilySize,
                format: .number
            )
            VisualizationCard(
                title: "Married-couple Families",
                latestValue: data.marriedCoupleFamiliesP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.marriedCoupleFamiliesP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.marriedCoupleFamiliesP,
                format: .percent
            )
            VisualizationCard(
                title: "Enrolled in High School",
                latestValue: data.schoolEnrolledP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.schoolEnrolledP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.schoolEnrolledP,
                format: .percent
            )
            VisualizationCard(
                title: "High School Grad+",
                latestValue: data.highSchoolGradP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.highSchoolGradP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.highSchoolGradP,
                format: .percent
            )
            VisualizationCard(
                title: "Bachelor's Degree+",
                latestValue: data.bachelorsOrHigherP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.bachelorsOrHigherP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.bachelorsOrHigherP,
                format: .percent
            )
            VisualizationCard(
                title: "Disabled Population",
                latestValue: data.civilianVeteranP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.civilianVeteranP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.civilianVeteranP,
                format: .percent
            )
            VisualizationCard(
                title: "Veteran Population",
                latestValue: data.foreignBornP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.foreignBornP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.foreignBornP,
                format: .percent
            )
            VisualizationCard(
                title: "Speaks non-English Language",
                latestValue: data.speaksOtherLanguageP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.speaksOtherLanguageP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.speaksOtherLanguageP,
                format: .percent
            )
            VisualizationCard(
                title: "Has Computer",
                latestValue: data.hasComputerP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.hasComputerP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.hasComputerP,
                format: .percent
            )
            VisualizationCard(
                title: "Has Broadband",
                latestValue: data.hasBroadbandP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.hasBroadbandP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.hasBroadbandP,
                format: .percent
            )
            VisualizationCard(
                title: "Unmarried Women Births",
                latestValue: data.unmarriedWomenBirthsP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.unmarriedWomenBirthsP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.unmarriedWomenBirthsP,
                format: .percent
            )
            VisualizationCard(
                title: "Foreign-born Population",
                latestValue: data.foreignBornPopP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.foreignBornPopP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.foreignBornPopP,
                format: .percent
            )
            VisualizationCard(
                title: "US-born Population",
                latestValue: data.usBornPopP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.usBornPopP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.usBornPopP,
                format: .percent
            )
            VisualizationCard(
                title: "Grandparents Responsible",
                latestValue: data.grandparentsResponsibleP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.grandparentsResponsibleP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.grandparentsResponsibleP,
                format: .percent
            )
            VisualizationCard(
                title: "American-ancestry Population",
                latestValue: data.naturalizedCitizenP,
                historicalData: historicalSocialData.mapValues { $0 as Any },
                latestComparisonValue: comparisonSocialData?.naturalizedCitizenP,
                historicalComparisonData: historicalComparisonSocialData.mapValues { $0 as Any },
                keyPath: \SocialData.naturalizedCitizenP,
                format: .percent
            )
        }
    }
    
    @ViewBuilder
    private var economicCards: some View {
        if let data = economicData {
            VisualizationCard(
                title: "Employed",
                latestValue: data.inLaborForceP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.inLaborForceP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.inLaborForceP,
                format: .percent
            )
            VisualizationCard(
                title: "Unemployment Rate",
                latestValue: data.unemploymentRateP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.unemploymentRateP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.unemploymentRateP,
                format: .percent
            )
            VisualizationCard(
                title: "Mean Travel Time to Work",
                latestValue: data.meanTravelTime,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.meanTravelTime,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.meanTravelTime,
                format: .none
            )
            VisualizationCard(
                title: "Management/Sci/Arts Occ.",
                latestValue: data.managementOccupationsP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.managementOccupationsP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.managementOccupationsP,
                format: .percent
            )
            VisualizationCard(
                title: "Construction/Maint. Occ.",
                latestValue: data.constructionOccupationsP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.constructionOccupationsP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.constructionOccupationsP,
                format: .percent
            )
            VisualizationCard(
                title: "Educational, Health Care Svcs",
                latestValue: data.privateWorkersP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.privateWorkersP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.privateWorkersP,
                format: .percent
            )
            VisualizationCard(
                title: "Government Workers",
                latestValue: data.governmentWorkersP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.governmentWorkersP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.governmentWorkersP,
                format: .percent
            )
            VisualizationCard(
                title: "Per capita Income",
                latestValue: data.meanIncome,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.meanIncome,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.meanIncome,
                format: .currency
            )
            VisualizationCard(
                title: "Median Household Income",
                latestValue: data.medianHouseholdIncome,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.medianHouseholdIncome,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.medianHouseholdIncome,
                format: .currency
            )
            VisualizationCard(
                title: "Mean Household Income",
                latestValue: data.meanHouseholdIncome,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.meanHouseholdIncome,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.meanHouseholdIncome,
                format: .currency
            )
            VisualizationCard(
                title: "With Social Security",
                latestValue: data.withSocialSecurityP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.withSocialSecurityP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.withSocialSecurityP,
                format: .percent
            )
            VisualizationCard(
                title: "With SNAP, Food Stamps",
                latestValue: data.withSnapP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.withSnapP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.withSnapP,
                format: .percent
            )
            VisualizationCard(
                title: "With Health Insurance",
                latestValue: data.withHealthInsuranceP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.withHealthInsuranceP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.withHealthInsuranceP,
                format: .percent
            )
            VisualizationCard(
                title: "With Private Insurance",
                latestValue: data.withPrivateHealthInsuranceP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.withPrivateHealthInsuranceP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.withPrivateHealthInsuranceP,
                format: .percent
            )
            VisualizationCard(
                title: "With Public Coverage",
                latestValue: data.withPublicCoverageP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.withPublicCoverageP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.withPublicCoverageP,
                format: .percent
            )
            VisualizationCard(
                title: "Below Poverty Level",
                latestValue: data.belowPovertyLevelP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.belowPovertyLevelP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.belowPovertyLevelP,
                format: .percent
            )
            VisualizationCard(
                title: "Drove Alone",
                latestValue: data.droveAloneP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.droveAloneP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.droveAloneP,
                format: .percent
            )
            VisualizationCard(
                title: "Carpooled",
                latestValue: data.carpooledP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.carpooledP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.carpooledP,
                format: .percent
            )
            VisualizationCard(
                title: "Public Transportation",
                latestValue: data.publicTransportationP,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.publicTransportationP,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.publicTransportationP,
                format: .percent
            )
            VisualizationCard(
                title: "Walked to Work",
                latestValue: data.perCapitaIncome,
                historicalData: historicalEconomicData.mapValues { $0 as Any },
                latestComparisonValue: comparisonEconomicData?.perCapitaIncome,
                historicalComparisonData: historicalComparisonEconomicData.mapValues { $0 as Any },
                keyPath: \EconomicData.perCapitaIncome,
                format: .percent
            )
        }
    }
    
    @ViewBuilder
    private var housingCards: some View {
        if let data = housingData {
            VisualizationCard(
                title: "Total Housing Units",
                latestValue: data.totalHousingUnits,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.totalHousingUnits,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.totalHousingUnits,
                format: .number
            )
            VisualizationCard(
                title: "Occupied Housing Units",
                latestValue: data.occupiedHousingUnitsP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.occupiedHousingUnitsP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.occupiedHousingUnitsP,
                format: .percent
            )
            VisualizationCard(
                title: "Vacant Housing Units",
                latestValue: data.vacantHousingUnitsP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.vacantHousingUnitsP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.vacantHousingUnitsP,
                format: .percent
            )
            VisualizationCard(
                title: "Owner-Occupied",
                latestValue: data.ownerOccupiedP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.ownerOccupiedP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.ownerOccupiedP,
                format: .percent
            )
            VisualizationCard(
                title: "Renter-Occupied",
                latestValue: data.renterOccupiedP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.renterOccupiedP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.renterOccupiedP,
                format: .percent
            )
            VisualizationCard(
                title: "Avg. Household Size (Owner)",
                latestValue: data.avgHouseholdSizeOwner,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.avgHouseholdSizeOwner,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.avgHouseholdSizeOwner,
                format: .none
            )
            VisualizationCard(
                title: "Avg. Household Size (Renter)",
                latestValue: data.avgHouseholdSizeRenter,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.avgHouseholdSizeRenter,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.avgHouseholdSizeRenter,
                format: .none
            )
            VisualizationCard(
                title: "1-Unit, Detached",
                latestValue: data.oneUnitDetachedP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.oneUnitDetachedP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.oneUnitDetachedP,
                format: .percent
            )
            VisualizationCard(
                title: "20+ Units",
                latestValue: data.tenOrMoreUnitsP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.tenOrMoreUnitsP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.tenOrMoreUnitsP,
                format: .percent
            )
            VisualizationCard(
                title: "Built 2020 or Later",
                latestValue: data.built2014OrLaterP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.built2014OrLaterP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.built2014OrLaterP,
                format: .percent
            )
            VisualizationCard(
                title: "3 Bedrooms",
                latestValue: data.threeBedroomsP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.threeBedroomsP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.threeBedroomsP,
                format: .percent
            )
            VisualizationCard(
                title: "Occupants > 1.5/Room",
                latestValue: data.occupantsPerRoom1_01OrMoreP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.occupantsPerRoom1_01OrMoreP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.occupantsPerRoom1_01OrMoreP,
                format: .percent
            )
            VisualizationCard(
                title: "Median Value",
                latestValue: data.medianValue,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.medianValue,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.medianValue,
                format: .currency
            )
            VisualizationCard(
                title: "With Mortgage",
                latestValue: data.withMortgageP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.withMortgageP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.withMortgageP,
                format: .percent
            )
            VisualizationCard(
                title: "Median Monthly Costs (Mortgage)",
                latestValue: data.medianMonthlyOwnerCostsWithMortgage,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.medianMonthlyOwnerCostsWithMortgage,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.medianMonthlyOwnerCostsWithMortgage,
                format: .currency
            )
            VisualizationCard(
                title: "Median Monthly Costs (No Mort.)",
                latestValue: data.medianMonthlyOwnerCostsWithoutMortgage,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.medianMonthlyOwnerCostsWithoutMortgage,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.medianMonthlyOwnerCostsWithoutMortgage,
                format: .currency
            )
            VisualizationCard(
                title: "Median Gross Rent",
                latestValue: data.medianGrossRent,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.medianGrossRent,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.medianGrossRent,
                format: .currency
            )
            VisualizationCard(
                title: "Gross Rent > 35% of Income",
                latestValue: data.grossRent35PercentOrMoreP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.grossRent35PercentOrMoreP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.grossRent35PercentOrMoreP,
                format: .percent
            )
            VisualizationCard(
                title: "No Vehicles",
                latestValue: data.noVehiclesP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.noVehiclesP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.noVehiclesP,
                format: .percent
            )
            VisualizationCard(
                title: "Utility Gas",
                latestValue: data.utilityGasP,
                historicalData: historicalHousingData.mapValues { $0 as Any },
                latestComparisonValue: comparisonHousingData?.utilityGasP,
                historicalComparisonData: historicalComparisonHousingData.mapValues { $0 as Any },
                keyPath: \HousingData.utilityGasP,
                format: .percent
            )
        }
    }
}
