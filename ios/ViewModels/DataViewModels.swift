//
// File: DataViewModel.swift (MODIFIED)
// Folder: ViewModels
//

import Foundation

// This class will handle fetching and processing the data from the API
class DataViewModel: ObservableObject {
    @Published var dataForLocationA: [CensusData] = []
    @Published var dataForLocationB: [CensusData] = []
    @Published var isComparing = false
    @Published var selectedHistoricalPeriods: Set<String> = []

    private var baseData: CensusData?

    func fetchData(for location: String) {
        // --- Placeholder for API Call ---
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let initialData = CensusData(
                period: "2018-2022",
                locationName: location,
                totalPopulation: 3820124,
                medianAge: 38.5,
                medianIncome: 75235
            )
            self.baseData = initialData
            self.dataForLocationA = [initialData]
            
            // Reset comparison and historical data
            self.dataForLocationB = []
            self.isComparing = false
            self.selectedHistoricalPeriods = []
        }
    }
    
    func fetchDataForComparison(location: String) {
        // --- Placeholder for API Call for the second location ---
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dataForLocationB = [
                CensusData(
                    period: "2018-2022",
                    locationName: location,
                    totalPopulation: 8804190,
                    medianAge: 35.8,
                    medianIncome: 70663
                )
            ]
            self.isComparing = true
        }
    }
    
    func toggleHistoricalPeriod(_ period: String) {
        if selectedHistoricalPeriods.contains(period) {
            selectedHistoricalPeriods.remove(period)
            dataForLocationA.removeAll { $0.period == period }
        } else {
            selectedHistoricalPeriods.insert(period)
            // Add dummy data for the selected period
            if period == "2017-2021" {
                dataForLocationA.append(CensusData(
                    period: "2017-2021",
                    locationName: baseData?.locationName ?? "",
                    totalPopulation: 3750000,
                    medianAge: 37.2,
                    medianIncome: 68112
                ))
            } else if period == "2012-2016" {
                dataForLocationA.append(CensusData(
                    period: "2012-2016",
                    locationName: baseData?.locationName ?? "",
                    totalPopulation: 3690000,
                    medianAge: 36.8,
                    medianIncome: 62543
                ))
            }
        }
        // Ensure the data is always sorted correctly
        dataForLocationA.sort { $0.period > $1.period }
    }
}
