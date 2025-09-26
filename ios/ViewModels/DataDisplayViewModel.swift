//
// File: DataDisplayViewModel.swift (MODIFIED)
//

import Foundation

@MainActor
class DataDisplayViewModel: ObservableObject {
    // MARK: - Published Properties for Primary Location
    @Published var latestOverviewData: OverviewData?
    @Published var historicalOverviewData: [String: OverviewData] = [:]
    @Published var latestDemographicData: DemographicData?
    @Published var historicalDemographicData: [String: DemographicData] = [:]
    @Published var latestSocialData: SocialData?
    @Published var historicalSocialData: [String: SocialData] = [:]
    @Published var latestEconomicData: EconomicData?
    @Published var historicalEconomicData: [String: EconomicData] = [:]
    @Published var latestHousingData: HousingData?
    @Published var historicalHousingData: [String: HousingData] = [:]
    
    // MARK: - Published Properties for Comparison Location
    @Published var isComparing = false
    @Published var comparisonLocationInfo: (level: SelectionView.GeoLevel, name: String, fips: String)?
    @Published var latestComparisonData: OverviewData?
    @Published var historicalComparisonData: [String: OverviewData] = [:]
    @Published var latestComparisonDemographicData: DemographicData?
    @Published var historicalComparisonDemographicData: [String: DemographicData] = [:]
    @Published var latestComparisonSocialData: SocialData?
    @Published var historicalComparisonSocialData: [String: SocialData] = [:]
    @Published var latestComparisonEconomicData: EconomicData?
    @Published var historicalComparisonEconomicData: [String: EconomicData] = [:]
    @Published var latestComparisonHousingData: HousingData?
    @Published var historicalComparisonHousingData: [String: HousingData] = [:]
    @Published var comparisonStateFips: String?
    
    // MARK: - State Properties
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = CensusAPIService()
    
    // MARK: - Data Fetching Methods
    
    func fetchLatestData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, category: String) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                switch category {
                case "Overview":
                    self.latestOverviewData = try await apiService.fetchLatestOverviewData(for: location, stateFips: stateFips)
                case "Demographic":
                    self.latestDemographicData = try await apiService.fetchLatestDemographicData(for: location, stateFips: stateFips)
                case "Social":
                    self.latestSocialData = try await apiService.fetchLatestSocialData(for: location, stateFips: stateFips)
                case "Economic":
                    self.latestEconomicData = try await apiService.fetchLatestEconomicData(for: location, stateFips: stateFips)
                case "Housing":
                    self.latestHousingData = try await apiService.fetchLatestHousingData(for: location, stateFips: stateFips)
                default:
                    // For now, load overview data for other categories
                    self.latestOverviewData = try await apiService.fetchLatestOverviewData(for: location, stateFips: stateFips)
                }
            } catch { self.errorMessage = "Failed to fetch latest data." }
            isLoading = false
        }
    }
    
    func fetchOrRemoveHistoricalData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String, category: String, isForComparison: Bool) {
        isLoading = true
        Task {
            do {
                switch category {
                case "Overview":
                    let targetDictionary = isForComparison ? historicalComparisonData : historicalOverviewData
                    if targetDictionary[year] != nil {
                        if isForComparison { historicalComparisonData.removeValue(forKey: year) }
                        else { historicalOverviewData.removeValue(forKey: year) }
                    } else {
                        let data = try await apiService.fetchHistoricalOverviewData(for: location, stateFips: stateFips, year: year)
                        if isForComparison { self.historicalComparisonData[year] = data }
                        else { self.historicalOverviewData[year] = data }
                    }
                case "Demographic":
                    let targetDictionary = isForComparison ? historicalComparisonDemographicData : historicalDemographicData
                    if targetDictionary[year] != nil {
                        if isForComparison { historicalComparisonDemographicData.removeValue(forKey: year) }
                        else { historicalDemographicData.removeValue(forKey: year) }
                    } else {
                        let data = try await apiService.fetchHistoricalDemographicData(for: location, stateFips: stateFips, year: year)
                        if isForComparison { self.historicalComparisonDemographicData[year] = data }
                        else { self.historicalDemographicData[year] = data }
                    }
                case "Social":
                    let targetDictionary = isForComparison ? historicalComparisonSocialData : historicalSocialData
                    if targetDictionary[year] != nil {
                        if isForComparison { historicalComparisonSocialData.removeValue(forKey: year) }
                        else { historicalSocialData.removeValue(forKey: year) }
                    } else {
                        let data = try await apiService.fetchHistoricalSocialData(for: location, stateFips: stateFips, year: year)
                        if isForComparison { self.historicalComparisonSocialData[year] = data }
                        else { self.historicalSocialData[year] = data }
                    }
                case "Economic":
                    let targetDictionary = isForComparison ? historicalComparisonEconomicData : historicalEconomicData
                    if targetDictionary[year] != nil {
                        if isForComparison { historicalComparisonEconomicData.removeValue(forKey: year) }
                        else { historicalEconomicData.removeValue(forKey: year) }
                    } else {
                        let data = try await apiService.fetchHistoricalEconomicData(for: location, stateFips: stateFips, year: year)
                        if isForComparison { self.historicalComparisonEconomicData[year] = data }
                        else { self.historicalEconomicData[year] = data }
                    }
                case "Housing":
                    let targetDictionary = isForComparison ? historicalComparisonHousingData : historicalHousingData
                    if targetDictionary[year] != nil {
                        if isForComparison { historicalComparisonHousingData.removeValue(forKey: year) }
                        else { historicalHousingData.removeValue(forKey: year) }
                    } else {
                        let data = try await apiService.fetchHistoricalHousingData(for: location, stateFips: stateFips, year: year)
                        if isForComparison { self.historicalComparisonHousingData[year] = data }
                        else { self.historicalHousingData[year] = data }
                    }
                default:
                    // For now, load overview data for other categories
                    let targetDictionary = isForComparison ? historicalComparisonData : historicalOverviewData
                    if targetDictionary[year] != nil {
                        if isForComparison { historicalComparisonData.removeValue(forKey: year) }
                        else { historicalOverviewData.removeValue(forKey: year) }
                    } else {
                        let data = try await apiService.fetchHistoricalOverviewData(for: location, stateFips: stateFips, year: year)
                        if isForComparison { self.historicalComparisonData[year] = data }
                        else { self.historicalOverviewData[year] = data }
                    }
                }
            } catch { self.errorMessage = "Failed to load data for \(year)." }
            isLoading = false
        }
    }
    
    /**
     Fetches all necessary data for the second, comparison location.
     */
    func fetchComparisonData(location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, category: String) {
        isComparing = true
        comparisonLocationInfo = location
        comparisonStateFips = stateFips
        isLoading = true
        
        Task {
            do {
                switch category {
                case "Overview":
                    self.latestComparisonData = try await apiService.fetchLatestOverviewData(for: location, stateFips: stateFips)
                    let selectedYears = historicalOverviewData.keys
                    for year in selectedYears {
                        let historicalData = try await apiService.fetchHistoricalOverviewData(for: location, stateFips: stateFips, year: year)
                        self.historicalComparisonData[year] = historicalData
                    }
                case "Demographic":
                    self.latestComparisonDemographicData = try await apiService.fetchLatestDemographicData(for: location, stateFips: stateFips)
                    let selectedYears = historicalDemographicData.keys
                    for year in selectedYears {
                        let historicalData = try await apiService.fetchHistoricalDemographicData(for: location, stateFips: stateFips, year: year)
                        self.historicalComparisonDemographicData[year] = historicalData
                    }
                case "Social":
                    self.latestComparisonSocialData = try await apiService.fetchLatestSocialData(for: location, stateFips: stateFips)
                    let selectedYears = historicalSocialData.keys
                    for year in selectedYears {
                        let historicalData = try await apiService.fetchHistoricalSocialData(for: location, stateFips: stateFips, year: year)
                        self.historicalComparisonSocialData[year] = historicalData
                    }
                case "Economic":
                    self.latestComparisonEconomicData = try await apiService.fetchLatestEconomicData(for: location, stateFips: stateFips)
                    let selectedYears = historicalEconomicData.keys
                    for year in selectedYears {
                        let historicalData = try await apiService.fetchHistoricalEconomicData(for: location, stateFips: stateFips, year: year)
                        self.historicalComparisonEconomicData[year] = historicalData
                    }
                case "Housing":
                    self.latestComparisonHousingData = try await apiService.fetchLatestHousingData(for: location, stateFips: stateFips)
                    let selectedYears = historicalHousingData.keys
                    for year in selectedYears {
                        let historicalData = try await apiService.fetchHistoricalHousingData(for: location, stateFips: stateFips, year: year)
                        self.historicalComparisonHousingData[year] = historicalData
                    }
                default:
                    self.latestComparisonData = try await apiService.fetchLatestOverviewData(for: location, stateFips: stateFips)
                    let selectedYears = historicalOverviewData.keys
                    for year in selectedYears {
                        let historicalData = try await apiService.fetchHistoricalOverviewData(for: location, stateFips: stateFips, year: year)
                        self.historicalComparisonData[year] = historicalData
                    }
                }
            } catch {
                self.errorMessage = "Failed to load comparison data."
            }
            isLoading = false
        }
    }
    
    /**
     Clears all data related to the comparison location and exits comparison mode.
     */
    func clearComparisonData() {
        isComparing = false
        comparisonLocationInfo = nil
        latestComparisonData = nil
        historicalComparisonData = [:]
        latestComparisonDemographicData = nil
        historicalComparisonDemographicData = [:]
        latestComparisonSocialData = nil
        historicalComparisonSocialData = [:]
        latestComparisonEconomicData = nil
        historicalComparisonEconomicData = [:]
        latestComparisonHousingData = nil
        historicalComparisonHousingData = [:]
        comparisonStateFips = nil
    }
}
