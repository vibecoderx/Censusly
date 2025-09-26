//
// File: DataDisplayView.swift (MODIFIED)
//

import SwiftUI

struct DataDisplayView: View {
    enum DisplayMode: String, CaseIterable, Identifiable {
        case table = "Table"
        case visuals = "Visuals"
        var id: Self { self }
    }
    
    let location: (level: SelectionView.GeoLevel, name: String, fips: String)
    let stateFips: String
    let category: String
    
    @StateObject private var viewModel = DataDisplayViewModel()
    
    @State private var showingCompareSheet = false
    @State private var selectedHistoricalYears: Set<String> = []
    @State private var orientation: UIInterfaceOrientationMask = .portrait
    @State private var displayMode: DisplayMode = .table
    
    private let availableYears = ["2022", "2021", "2020", "2019"]
    
    private var sortedHistoricalYears: [String] {
        selectedHistoricalYears.sorted(by: >)
    }

    var body: some View {
        viewContent
            .navigationTitle("\(location.name) - \(category)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isComparing {
                        Button(action: {
                            viewModel.clearComparisonData()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    } else {
                        Button(action: { showingCompareSheet = true }) {
                            Image(systemName: "plus.square.on.square")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(availableYears, id: \.self) { year in
                            Toggle(year, isOn: Binding(
                                get: { selectedHistoricalYears.contains(year) },
                                set: { isOn in
                                    if isOn { selectedHistoricalYears.insert(year) }
                                    else { selectedHistoricalYears.remove(year) }
                                    
                                    viewModel.fetchOrRemoveHistoricalData(for: location, stateFips: stateFips, year: year, category: category, isForComparison: false)
                                    
                                    if viewModel.isComparing, let comparisonLocation = viewModel.comparisonLocationInfo {
                                        viewModel.fetchOrRemoveHistoricalData(for: comparisonLocation, stateFips: viewModel.comparisonStateFips ?? "", year: year, category: category, isForComparison: true)
                                    }
                                }
                            ))
                        }
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .disabled(displayMode == .table && viewModel.isComparing)
                }
            }
            .sheet(isPresented: $showingCompareSheet) {
                ComparisonSelectionView { selectedLocation, selectedStateFips in
                    selectedHistoricalYears.removeAll()
                    viewModel.historicalOverviewData.removeAll()
                    viewModel.historicalDemographicData.removeAll()
                    viewModel.historicalSocialData.removeAll()
                    viewModel.historicalEconomicData.removeAll()
                    viewModel.historicalHousingData.removeAll()
                    viewModel.fetchComparisonData(location: selectedLocation, stateFips: selectedStateFips, category: category)
                }
            }
            .onAppear {
                viewModel.fetchLatestData(for: location, stateFips: stateFips, category: category)
            }
            .onDisappear { orientation = .portrait }
            .onChange(of: selectedHistoricalYears) {
                orientation = selectedHistoricalYears.isEmpty ? .portrait : .landscape
            }
            .lockOrientation(to: orientation)
    }
    
    @ViewBuilder
    private var viewContent: some View {
        VStack {
            Picker("Display Mode", selection: $displayMode) {
                ForEach(DisplayMode.allCases) { Text($0.rawValue) }
            }.pickerStyle(.segmented).padding(.horizontal)
            
            if displayMode == .table {
                switch category {
                case "Demographic":
                    demographicContent
                case "Social":
                    socialContent
                case "Economic":
                    economicContent
                case "Housing":
                    housingContent
                default:
                    overviewContent
                }
            } else {
                switch category {
                case "Demographic":
                    demographicVisualsContent
                case "Social":
                    socialVisualsContent
                case "Economic":
                    economicVisualsContent
                case "Housing":
                    housingVisualsContent
                default:
                    overviewVisualsContent
                }
            }
        }
    }
    
    private var overviewContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let errorMessage = viewModel.errorMessage { Text(errorMessage).foregroundColor(.red).padding() }
            else if let latestData = viewModel.latestOverviewData {
                List {
                    Section(header: selectedHistoricalYears.isEmpty ? AnyView(comparisonHeaderView) : AnyView(historicalHeaderView)) {
                        if selectedHistoricalYears.isEmpty {
                            DataRow(label: "Total Population", value: latestData.totalPopulation, comparisonValue: viewModel.latestComparisonData?.totalPopulation, format: .number)
                            DataRow(label: "Median Age", value: latestData.medianAge, comparisonValue: viewModel.latestComparisonData?.medianAge)
                            DataRow(label: "Median Household Income", value: latestData.medianIncome, comparisonValue: viewModel.latestComparisonData?.medianIncome, format: .currency)
                            DataRow(label: "High School Grad+", value: latestData.highSchoolGradP, comparisonValue: viewModel.latestComparisonData?.highSchoolGradP, format: .percent)
                            DataRow(label: "Poverty Rate", value: latestData.povertyP, comparisonValue: viewModel.latestComparisonData?.povertyP, format: .percent)
                            DataRow(label: "Owner-Occupied Housing", value: latestData.ownerOccupiedP, comparisonValue: viewModel.latestComparisonData?.ownerOccupiedP, format: .percent)
                            DataRow(label: "Avg. Commute", value: latestData.avgCommuteTime, comparisonValue: viewModel.latestComparisonData?.avgCommuteTime)
                            DataRow(label: "Median Home Value", value: latestData.medianHomeValue, comparisonValue: viewModel.latestComparisonData?.medianHomeValue, format: .currency)
                            DataRow(label: "Unemployment Rate", value: latestData.unemploymentP, comparisonValue: viewModel.latestComparisonData?.unemploymentP, format: .percent)
                            // FIX: Added 5 new DataRow views for the new overview fields.
                            DataRow(label: "Foreign-Born", value: latestData.foreignBorn, comparisonValue: viewModel.latestComparisonData?.foreignBorn, format: .number)
                            DataRow(label: "Veterans", value: latestData.veterans, comparisonValue: viewModel.latestComparisonData?.veterans, format: .number)
                            DataRow(label: "Households w/ Computer", value: latestData.householdsWithComputerP, comparisonValue: viewModel.latestComparisonData?.householdsWithComputerP, format: .percent)
                            DataRow(label: "Bachelor's Degree+", value: latestData.bachelorsOrHigherP, comparisonValue: viewModel.latestComparisonData?.bachelorsOrHigherP, format: .percent)
                            DataRow(label: "Median Gross Rent", value: latestData.medianGrossRent, comparisonValue: viewModel.latestComparisonData?.medianGrossRent, format: .currency)

                        } else {
                            historicalRow(label: "Total Population", latestValue: latestData.totalPopulation, historicalData: viewModel.historicalOverviewData, keyPath: \.totalPopulation, format: .number)
                            historicalRow(label: "Median Age", latestValue: latestData.medianAge, historicalData: viewModel.historicalOverviewData, keyPath: \.medianAge)
                            historicalRow(label: "Median Household Income", latestValue: latestData.medianIncome, historicalData: viewModel.historicalOverviewData, keyPath: \.medianIncome, format: .currency)
                            historicalRow(label: "High School Grad+", latestValue: latestData.highSchoolGradP, historicalData: viewModel.historicalOverviewData, keyPath: \.highSchoolGradP, format: .percent)
                            historicalRow(label: "Poverty Rate", latestValue: latestData.povertyP, historicalData: viewModel.historicalOverviewData, keyPath: \.povertyP, format: .percent)
                            historicalRow(label: "Owner-Occupied Housing", latestValue: latestData.ownerOccupiedP, historicalData: viewModel.historicalOverviewData, keyPath: \.ownerOccupiedP, format: .percent)
                            historicalRow(label: "Avg. Commute", latestValue: latestData.avgCommuteTime, historicalData: viewModel.historicalOverviewData, keyPath: \.avgCommuteTime)
                            historicalRow(label: "Median Home Value", latestValue: latestData.medianHomeValue, historicalData: viewModel.historicalOverviewData, keyPath: \.medianHomeValue, format: .currency)
                            historicalRow(label: "Unemployment Rate", latestValue: latestData.unemploymentP, historicalData: viewModel.historicalOverviewData, keyPath: \.unemploymentP, format: .percent)
                            // FIX: Added 5 new historicalRow views.
                            historicalRow(label: "Foreign-Born", latestValue: latestData.foreignBorn, historicalData: viewModel.historicalOverviewData, keyPath: \.foreignBorn, format: .number)
                            historicalRow(label: "Veterans", latestValue: latestData.veterans, historicalData: viewModel.historicalOverviewData, keyPath: \.veterans, format: .number)
                            historicalRow(label: "Households w/ Computer", latestValue: latestData.householdsWithComputerP, historicalData: viewModel.historicalOverviewData, keyPath: \.householdsWithComputerP, format: .percent)
                            historicalRow(label: "Bachelor's Degree+", latestValue: latestData.bachelorsOrHigherP, historicalData: viewModel.historicalOverviewData, keyPath: \.bachelorsOrHigherP, format: .percent)
                            historicalRow(label: "Median Gross Rent", latestValue: latestData.medianGrossRent, historicalData: viewModel.historicalOverviewData, keyPath: \.medianGrossRent, format: .currency)
                        }
                    }
                }
            } else { Text("No data available.") }
        }
    }
    
    private var demographicContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let errorMessage = viewModel.errorMessage { Text(errorMessage).foregroundColor(.red).padding() }
            else if let latestData = viewModel.latestDemographicData {
                List {
                    Section(header: selectedHistoricalYears.isEmpty ? AnyView(comparisonHeaderView) : AnyView(historicalHeaderView)) {
                        if selectedHistoricalYears.isEmpty {
                            DataRow(label: "Total Population", value: latestData.totalPopulation, comparisonValue: viewModel.latestComparisonDemographicData?.totalPopulation, format: .number)
                            DataRow(label: "Male Population", value: latestData.malePopulation, comparisonValue: viewModel.latestComparisonDemographicData?.malePopulation, format: .number)
                            DataRow(label: "Female Population", value: latestData.femalePopulation, comparisonValue: viewModel.latestComparisonDemographicData?.femalePopulation, format: .number)
                            DataRow(label: "Median Age", value: latestData.medianAge, comparisonValue: viewModel.latestComparisonDemographicData?.medianAge)
                            DataRow(label: "Under 18", value: latestData.under18, comparisonValue: viewModel.latestComparisonDemographicData?.under18, format: .number)
                            DataRow(label: "65 and Over", value: latestData.over65, comparisonValue: viewModel.latestComparisonDemographicData?.over65, format: .number)
                            DataRow(label: "White", value: latestData.whiteP, comparisonValue: viewModel.latestComparisonDemographicData?.whiteP, format: .percent)
                            DataRow(label: "Black", value: latestData.blackP, comparisonValue: viewModel.latestComparisonDemographicData?.blackP, format: .percent)
                            DataRow(label: "Native American/Alaska", value: latestData.nativeP, comparisonValue: viewModel.latestComparisonDemographicData?.nativeP, format: .percent)
                            DataRow(label: "Asian", value: latestData.asianP, comparisonValue: viewModel.latestComparisonDemographicData?.asianP, format: .percent)
                            DataRow(label: "Pacific Islander", value: latestData.pacificP, comparisonValue: viewModel.latestComparisonDemographicData?.pacificP, format: .percent)
                            DataRow(label: "One Race", value: latestData.otherP, comparisonValue: viewModel.latestComparisonDemographicData?.otherP, format: .percent)
                            DataRow(label: "Two or More Races", value: latestData.twoOrMoreP, comparisonValue: viewModel.latestComparisonDemographicData?.twoOrMoreP, format: .percent)
                            DataRow(label: "Hispanic", value: latestData.hispanicP, comparisonValue: viewModel.latestComparisonDemographicData?.hispanicP, format: .percent)
                            DataRow(label: "White (Non-Hispanic)", value: latestData.whiteNonHispP, comparisonValue: viewModel.latestComparisonDemographicData?.whiteNonHispP, format: .percent)
                            DataRow(label: "Sex Ratio (M / 100 F)", value: latestData.totalHousing, comparisonValue: viewModel.latestComparisonDemographicData?.totalHousing, format: .number)
                            DataRow(label: "Born in USA", value: latestData.citizen18AndOverP, comparisonValue: viewModel.latestComparisonDemographicData?.citizen18AndOverP, format: .percent)
                            DataRow(label: "Population 21+", value: latestData.pop21AndOver, comparisonValue: viewModel.latestComparisonDemographicData?.pop21AndOver, format: .percent)
                            DataRow(label: "Population 18+", value: latestData.pop18AndOver, comparisonValue: viewModel.latestComparisonDemographicData?.pop18AndOver, format: .percent)
                            DataRow(label: "English-language only households", value: latestData.sexRatio, comparisonValue: viewModel.latestComparisonDemographicData?.sexRatio,
                                    format: .percent)
                        } else {
                            historicalRow(label: "Total Population", latestValue: latestData.totalPopulation, historicalData: viewModel.historicalDemographicData, keyPath: \.totalPopulation, format: .number)
                            historicalRow(label: "Male Population", latestValue: latestData.malePopulation, historicalData: viewModel.historicalDemographicData, keyPath: \.malePopulation, format: .number)
                            historicalRow(label: "Female Population", latestValue: latestData.femalePopulation, historicalData: viewModel.historicalDemographicData, keyPath: \.femalePopulation, format: .number)
                            historicalRow(label: "Median Age", latestValue: latestData.medianAge, historicalData: viewModel.historicalDemographicData, keyPath: \.medianAge)
                            historicalRow(label: "Under 18", latestValue: latestData.under18, historicalData: viewModel.historicalDemographicData, keyPath: \.under18, format: .number)
                            historicalRow(label: "65 and Over", latestValue: latestData.over65, historicalData: viewModel.historicalDemographicData, keyPath: \.over65, format: .number)
                            historicalRow(label: "White", latestValue: latestData.whiteP, historicalData: viewModel.historicalDemographicData, keyPath: \.whiteP, format: .percent)
                            historicalRow(label: "Black", latestValue: latestData.blackP, historicalData: viewModel.historicalDemographicData, keyPath: \.blackP, format: .percent)
                            historicalRow(label: "Native American/Alaska", latestValue: latestData.nativeP, historicalData: viewModel.historicalDemographicData, keyPath: \.nativeP, format: .percent)
                            historicalRow(label: "Asian", latestValue: latestData.asianP, historicalData: viewModel.historicalDemographicData, keyPath: \.asianP, format: .percent)
                            historicalRow(label: "Pacific Islander", latestValue: latestData.pacificP, historicalData: viewModel.historicalDemographicData, keyPath: \.pacificP, format: .percent)
                            historicalRow(label: "One Race", latestValue: latestData.otherP, historicalData: viewModel.historicalDemographicData, keyPath: \.otherP, format: .percent)
                            historicalRow(label: "Two or More Races", latestValue: latestData.twoOrMoreP, historicalData: viewModel.historicalDemographicData, keyPath: \.twoOrMoreP, format: .percent)
                            historicalRow(label: "Hispanic", latestValue: latestData.hispanicP, historicalData: viewModel.historicalDemographicData, keyPath: \.hispanicP, format: .percent)
                            historicalRow(label: "White (Non-Hispanic)", latestValue: latestData.whiteNonHispP, historicalData: viewModel.historicalDemographicData, keyPath: \.whiteNonHispP, format: .percent)
                            historicalRow(label: "Sex Ratio (M / 100 F)", latestValue: latestData.totalHousing, historicalData: viewModel.historicalDemographicData, keyPath: \.totalHousing, format: .number)
                            historicalRow(label: "Born in USA", latestValue: latestData.citizen18AndOverP, historicalData: viewModel.historicalDemographicData, keyPath: \.citizen18AndOverP, format: .percent)
                            historicalRow(label: "Population 21+", latestValue: latestData.pop21AndOver, historicalData: viewModel.historicalDemographicData, keyPath: \.pop21AndOver, format: .percent)
                            historicalRow(label: "Population 18+", latestValue: latestData.pop18AndOver, historicalData: viewModel.historicalDemographicData, keyPath: \.pop18AndOver, format: .percent)
                            historicalRow(label: "English-language only households", latestValue: latestData.sexRatio, historicalData: viewModel.historicalDemographicData, keyPath: \.sexRatio,
                                format: .percent)
                        }
                    }
                }
            } else { Text("No data available.") }
        }
    }
    
    private var socialContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let errorMessage = viewModel.errorMessage { Text(errorMessage).foregroundColor(.red).padding() }
            else if let latestData = viewModel.latestSocialData {
                List {
                    Section(header: selectedHistoricalYears.isEmpty ? AnyView(comparisonHeaderView) : AnyView(historicalHeaderView)) {
                        if selectedHistoricalYears.isEmpty {
                            DataRow(label: "Total Households", value: latestData.totalHouseholds, comparisonValue: viewModel.latestComparisonSocialData?.totalHouseholds, format: .number)
                            DataRow(label: "Households with <18", value: latestData.householdsWithUnder18, comparisonValue: viewModel.latestComparisonSocialData?.householdsWithUnder18, format: .percent)
                            DataRow(label: "Households with 65+", value: latestData.householdsWithOver65, comparisonValue: viewModel.latestComparisonSocialData?.householdsWithOver65, format: .percent)
                            DataRow(label: "Avg. Household Size", value: latestData.avgHouseholdSize, comparisonValue: viewModel.latestComparisonSocialData?.avgHouseholdSize,
                                format: .number)
                            DataRow(label: "Cohabiting couple household", value: latestData.totalFamilies, comparisonValue: viewModel.latestComparisonSocialData?.totalFamilies, format: .percent)
                            DataRow(label: "Avg. Family Size", value: latestData.avgFamilySize, comparisonValue: viewModel.latestComparisonSocialData?.avgFamilySize,
                                format: .number)
                            DataRow(label: "Married-couple Families", value: latestData.marriedCoupleFamiliesP, comparisonValue: viewModel.latestComparisonSocialData?.marriedCoupleFamiliesP, format: .percent)
                            DataRow(label: "Enrolled in High School", value: latestData.schoolEnrolledP, comparisonValue: viewModel.latestComparisonSocialData?.schoolEnrolledP, format: .percent)
                            DataRow(label: "High School Grad+", value: latestData.highSchoolGradP, comparisonValue: viewModel.latestComparisonSocialData?.highSchoolGradP, format: .percent)
                            DataRow(label: "Bachelor's Degree+", value: latestData.bachelorsOrHigherP, comparisonValue: viewModel.latestComparisonSocialData?.bachelorsOrHigherP, format: .percent)
                            DataRow(label: "Disabled Population", value: latestData.civilianVeteranP, comparisonValue: viewModel.latestComparisonSocialData?.civilianVeteranP, format: .percent)
                            DataRow(label: "Veteran Population", value: latestData.foreignBornP, comparisonValue: viewModel.latestComparisonSocialData?.foreignBornP, format: .percent)
                            DataRow(label: "Speaks non-English Language", value: latestData.speaksOtherLanguageP, comparisonValue: viewModel.latestComparisonSocialData?.speaksOtherLanguageP, format: .percent)
                            DataRow(label: "Has Computer", value: latestData.hasComputerP, comparisonValue: viewModel.latestComparisonSocialData?.hasComputerP, format: .percent)
                            DataRow(label: "Has Broadband", value: latestData.hasBroadbandP, comparisonValue: viewModel.latestComparisonSocialData?.hasBroadbandP, format: .percent)
                            DataRow(label: "Unmarried Women Births", value: latestData.unmarriedWomenBirthsP, comparisonValue: viewModel.latestComparisonSocialData?.unmarriedWomenBirthsP, format: .percent)
                            DataRow(label: "Foreign-born Population", value: latestData.foreignBornPopP, comparisonValue: viewModel.latestComparisonSocialData?.foreignBornPopP, format: .percent)
                            DataRow(label: "US-born Population", value: latestData.usBornPopP, comparisonValue: viewModel.latestComparisonSocialData?.usBornPopP, format: .percent)
                            DataRow(label: "Grandparents Responsible", value: latestData.grandparentsResponsibleP, comparisonValue: viewModel.latestComparisonSocialData?.grandparentsResponsibleP, format: .percent)
                            DataRow(label: "American-ancestry Population", value: latestData.naturalizedCitizenP, comparisonValue: viewModel.latestComparisonSocialData?.naturalizedCitizenP, format: .percent)
                        } else {
                            historicalRow(label: "Total Households", latestValue: latestData.totalHouseholds, historicalData: viewModel.historicalSocialData, keyPath: \.totalHouseholds, format: .number)
                            historicalRow(label: "Households with <18", latestValue: latestData.householdsWithUnder18, historicalData: viewModel.historicalSocialData, keyPath: \.householdsWithUnder18, format: .percent)
                            historicalRow(label: "Households with 65+", latestValue: latestData.householdsWithOver65, historicalData: viewModel.historicalSocialData, keyPath: \.householdsWithOver65, format: .percent)
                            historicalRow(label: "Avg. Household Size", latestValue: latestData.avgHouseholdSize, historicalData: viewModel.historicalSocialData, keyPath: \.avgHouseholdSize)
                            historicalRow(label: "Cohabiting couple household", latestValue: latestData.totalFamilies, historicalData: viewModel.historicalSocialData, keyPath: \.totalFamilies, format: .percent)
                            historicalRow(label: "Avg. Family Size", latestValue: latestData.avgFamilySize, historicalData: viewModel.historicalSocialData, keyPath: \.avgFamilySize)
                            historicalRow(label: "Married-couple Families", latestValue: latestData.marriedCoupleFamiliesP, historicalData: viewModel.historicalSocialData, keyPath: \.marriedCoupleFamiliesP, format: .percent)
                            historicalRow(label: "Enrolled in High School", latestValue: latestData.schoolEnrolledP, historicalData: viewModel.historicalSocialData, keyPath: \.schoolEnrolledP, format: .percent)
                            historicalRow(label: "High School Grad+", latestValue: latestData.highSchoolGradP, historicalData: viewModel.historicalSocialData, keyPath: \.highSchoolGradP, format: .percent)
                            historicalRow(label: "Bachelor's Degree+", latestValue: latestData.bachelorsOrHigherP, historicalData: viewModel.historicalSocialData, keyPath: \.bachelorsOrHigherP, format: .percent)
                            historicalRow(label: "Disabled Population", latestValue: latestData.civilianVeteranP, historicalData: viewModel.historicalSocialData, keyPath: \.civilianVeteranP, format: .percent)
                            historicalRow(label: "Veteran Population", latestValue: latestData.foreignBornP, historicalData: viewModel.historicalSocialData, keyPath: \.foreignBornP, format: .percent)
                            historicalRow(label: "Speaks non-English Language", latestValue: latestData.speaksOtherLanguageP, historicalData: viewModel.historicalSocialData, keyPath: \.speaksOtherLanguageP, format: .percent)
                            historicalRow(label: "Has Computer", latestValue: latestData.hasComputerP, historicalData: viewModel.historicalSocialData, keyPath: \.hasComputerP, format: .percent)
                            historicalRow(label: "Has Broadband", latestValue: latestData.hasBroadbandP, historicalData: viewModel.historicalSocialData, keyPath: \.hasBroadbandP, format: .percent)
                            historicalRow(label: "Unmarried Women Births", latestValue: latestData.unmarriedWomenBirthsP, historicalData: viewModel.historicalSocialData, keyPath: \.unmarriedWomenBirthsP, format: .percent)
                            DataRow(label: "Foreign-born Population", value: latestData.foreignBornPopP, comparisonValue: viewModel.latestComparisonSocialData?.foreignBornPopP, format: .percent)
                            DataRow(label: "US-born Population", value: latestData.usBornPopP, comparisonValue: viewModel.latestComparisonSocialData?.usBornPopP, format: .percent)
                            historicalRow(label: "Grandparents Responsible", latestValue: latestData.grandparentsResponsibleP, historicalData: viewModel.historicalSocialData, keyPath: \.grandparentsResponsibleP, format: .percent)
                            historicalRow(label: "American-ancestry Population", latestValue: latestData.naturalizedCitizenP, historicalData: viewModel.historicalSocialData, keyPath: \.naturalizedCitizenP, format: .percent)
                        }
                    }
                }
            } else { Text("No data available.") }
        }
    }
    
    private var economicContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let errorMessage = viewModel.errorMessage { Text(errorMessage).foregroundColor(.red).padding() }
            else if let latestData = viewModel.latestEconomicData {
                List {
                    Section(header: selectedHistoricalYears.isEmpty ? AnyView(comparisonHeaderView) : AnyView(historicalHeaderView)) {
                        if selectedHistoricalYears.isEmpty {
                            DataRow(label: "Employed", value: latestData.inLaborForceP, comparisonValue: viewModel.latestComparisonEconomicData?.inLaborForceP, format: .percent)
                            DataRow(label: "Unemployment Rate", value: latestData.unemploymentRateP, comparisonValue: viewModel.latestComparisonEconomicData?.unemploymentRateP, format: .percent)
                            DataRow(label: "Mean Travel Time to Work", value: latestData.meanTravelTime, comparisonValue: viewModel.latestComparisonEconomicData?.meanTravelTime)
                            DataRow(label: "Management/Sci/Arts Occ.", value: latestData.managementOccupationsP, comparisonValue: viewModel.latestComparisonEconomicData?.managementOccupationsP, format: .percent)
                            DataRow(label: "Construction/Maint. Occ.", value: latestData.constructionOccupationsP, comparisonValue: viewModel.latestComparisonEconomicData?.constructionOccupationsP, format: .percent)
                            DataRow(label: "Educational, Health Care Svcs", value: latestData.privateWorkersP, comparisonValue: viewModel.latestComparisonEconomicData?.privateWorkersP, format: .percent)
                            DataRow(label: "Government Workers", value: latestData.governmentWorkersP, comparisonValue: viewModel.latestComparisonEconomicData?.governmentWorkersP, format: .percent)
                            DataRow(label: "Per capita Income", value: latestData.meanIncome, comparisonValue: viewModel.latestComparisonEconomicData?.meanIncome, format: .currency)
                            DataRow(label: "Median Household Income", value: latestData.medianHouseholdIncome, comparisonValue: viewModel.latestComparisonEconomicData?.medianHouseholdIncome, format: .currency)
                            DataRow(label: "Mean Household Income", value: latestData.meanHouseholdIncome, comparisonValue: viewModel.latestComparisonEconomicData?.meanHouseholdIncome, format: .currency)
                            DataRow(label: "With Social Security", value: latestData.withSocialSecurityP, comparisonValue: viewModel.latestComparisonEconomicData?.withSocialSecurityP, format: .percent)
                            DataRow(label: "With SNAP", value: latestData.withSnapP, comparisonValue: viewModel.latestComparisonEconomicData?.withSnapP, format: .percent)
                            DataRow(label: "With Health Insurance", value: latestData.withHealthInsuranceP, comparisonValue: viewModel.latestComparisonEconomicData?.withHealthInsuranceP, format: .percent)
                            DataRow(label: "With Private Insurance", value: latestData.withPrivateHealthInsuranceP, comparisonValue: viewModel.latestComparisonEconomicData?.withPrivateHealthInsuranceP, format: .percent)
                            DataRow(label: "With Public Coverage", value: latestData.withPublicCoverageP, comparisonValue: viewModel.latestComparisonEconomicData?.withPublicCoverageP, format: .percent)
                            DataRow(label: "Below Poverty Level", value: latestData.belowPovertyLevelP, comparisonValue: viewModel.latestComparisonEconomicData?.belowPovertyLevelP, format: .percent)
                            DataRow(label: "Drove Alone", value: latestData.droveAloneP, comparisonValue: viewModel.latestComparisonEconomicData?.droveAloneP, format: .percent)
                            DataRow(label: "Carpooled", value: latestData.carpooledP, comparisonValue: viewModel.latestComparisonEconomicData?.carpooledP, format: .percent)
                            DataRow(label: "Public Transportation", value: latestData.publicTransportationP, comparisonValue: viewModel.latestComparisonEconomicData?.publicTransportationP, format: .percent)
                            DataRow(label: "Walked to Work", value: latestData.perCapitaIncome, comparisonValue: viewModel.latestComparisonEconomicData?.perCapitaIncome, format: .percent)
                        } else {
                            historicalRow(label: "Employed", latestValue: latestData.inLaborForceP, historicalData: viewModel.historicalEconomicData, keyPath: \.inLaborForceP, format: .percent)
                            historicalRow(label: "Unemployment Rate", latestValue: latestData.unemploymentRateP, historicalData: viewModel.historicalEconomicData, keyPath: \.unemploymentRateP, format: .percent)
                            historicalRow(label: "Mean Travel Time to Work", latestValue: latestData.meanTravelTime, historicalData: viewModel.historicalEconomicData, keyPath: \.meanTravelTime)
                            historicalRow(label: "Management/Sci/Arts Occ.", latestValue: latestData.managementOccupationsP, historicalData: viewModel.historicalEconomicData, keyPath: \.managementOccupationsP, format: .percent)
                            historicalRow(label: "Construction/Maint. Occ.", latestValue: latestData.constructionOccupationsP, historicalData: viewModel.historicalEconomicData, keyPath: \.constructionOccupationsP, format: .percent)
                            historicalRow(label: "Educational, Health Care Svcs", latestValue: latestData.privateWorkersP, historicalData: viewModel.historicalEconomicData, keyPath: \.privateWorkersP, format: .percent)
                            historicalRow(label: "Government Workers", latestValue: latestData.governmentWorkersP, historicalData: viewModel.historicalEconomicData, keyPath: \.governmentWorkersP, format: .percent)
                            historicalRow(label: "Per capita Income", latestValue: latestData.meanIncome, historicalData: viewModel.historicalEconomicData, keyPath: \.meanIncome, format: .currency)
                            historicalRow(label: "Median Household Income", latestValue: latestData.medianHouseholdIncome, historicalData: viewModel.historicalEconomicData, keyPath: \.medianHouseholdIncome, format: .currency)
                            historicalRow(label: "Mean Household Income", latestValue: latestData.meanHouseholdIncome, historicalData: viewModel.historicalEconomicData, keyPath: \.meanHouseholdIncome, format: .currency)
                            historicalRow(label: "With Social Security", latestValue: latestData.withSocialSecurityP, historicalData: viewModel.historicalEconomicData, keyPath: \.withSocialSecurityP, format: .percent)
                            historicalRow(label: "With SNAP, Food Stamps", latestValue: latestData.withSnapP, historicalData: viewModel.historicalEconomicData, keyPath: \.withSnapP, format: .percent)
                            historicalRow(label: "With Health Insurance", latestValue: latestData.withHealthInsuranceP, historicalData: viewModel.historicalEconomicData, keyPath: \.withHealthInsuranceP, format: .percent)
                            historicalRow(label: "With Private Insurance", latestValue: latestData.withPrivateHealthInsuranceP, historicalData: viewModel.historicalEconomicData, keyPath: \.withPrivateHealthInsuranceP, format: .percent)
                            historicalRow(label: "With Public Coverage", latestValue: latestData.withPublicCoverageP, historicalData: viewModel.historicalEconomicData, keyPath: \.withPublicCoverageP, format: .percent)
                            historicalRow(label: "Below Poverty Level", latestValue: latestData.belowPovertyLevelP, historicalData: viewModel.historicalEconomicData, keyPath: \.belowPovertyLevelP, format: .percent)
                            historicalRow(label: "Drove Alone", latestValue: latestData.droveAloneP, historicalData: viewModel.historicalEconomicData, keyPath: \.droveAloneP, format: .percent)
                            historicalRow(label: "Carpooled", latestValue: latestData.carpooledP, historicalData: viewModel.historicalEconomicData, keyPath: \.carpooledP, format: .percent)
                            historicalRow(label: "Public Transportation", latestValue: latestData.publicTransportationP, historicalData: viewModel.historicalEconomicData, keyPath: \.publicTransportationP, format: .percent)
                            historicalRow(label: "Worked to Work", latestValue: latestData.perCapitaIncome, historicalData: viewModel.historicalEconomicData, keyPath: \.perCapitaIncome, format: .percent)
                        }
                    }
                }
            } else { Text("No data available.") }
        }
    }
    
    private var housingContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let errorMessage = viewModel.errorMessage { Text(errorMessage).foregroundColor(.red).padding() }
            else if let latestData = viewModel.latestHousingData {
                List {
                    Section(header: selectedHistoricalYears.isEmpty ? AnyView(comparisonHeaderView) : AnyView(historicalHeaderView)) {
                        if selectedHistoricalYears.isEmpty {
                            DataRow(label: "Total Housing Units", value: latestData.totalHousingUnits, comparisonValue: viewModel.latestComparisonHousingData?.totalHousingUnits, format: .number)
                            DataRow(label: "Occupied Housing Units", value: latestData.occupiedHousingUnitsP, comparisonValue: viewModel.latestComparisonHousingData?.occupiedHousingUnitsP, format: .percent)
                            DataRow(label: "Vacant Housing Units", value: latestData.vacantHousingUnitsP, comparisonValue: viewModel.latestComparisonHousingData?.vacantHousingUnitsP, format: .percent)
                            DataRow(label: "Owner-Occupied", value: latestData.ownerOccupiedP, comparisonValue: viewModel.latestComparisonHousingData?.ownerOccupiedP, format: .percent)
                            DataRow(label: "Renter-Occupied", value: latestData.renterOccupiedP, comparisonValue: viewModel.latestComparisonHousingData?.renterOccupiedP, format: .percent)
                            DataRow(label: "Avg. Household Size (Owner)", value: latestData.avgHouseholdSizeOwner, comparisonValue: viewModel.latestComparisonHousingData?.avgHouseholdSizeOwner)
                            DataRow(label: "Avg. Household Size (Renter)", value: latestData.avgHouseholdSizeRenter, comparisonValue: viewModel.latestComparisonHousingData?.avgHouseholdSizeRenter)
                            DataRow(label: "1-Unit, Detached", value: latestData.oneUnitDetachedP, comparisonValue: viewModel.latestComparisonHousingData?.oneUnitDetachedP, format: .percent)
                            DataRow(label: "20+ Units", value: latestData.tenOrMoreUnitsP, comparisonValue: viewModel.latestComparisonHousingData?.tenOrMoreUnitsP, format: .percent)
                            DataRow(label: "Built 2020 or Later", value: latestData.built2014OrLaterP, comparisonValue: viewModel.latestComparisonHousingData?.built2014OrLaterP, format: .percent)
                            DataRow(label: "3 Bedrooms", value: latestData.threeBedroomsP, comparisonValue: viewModel.latestComparisonHousingData?.threeBedroomsP, format: .percent)
                            DataRow(label: "Occupants > 1.5/Room", value: latestData.occupantsPerRoom1_01OrMoreP, comparisonValue: viewModel.latestComparisonHousingData?.occupantsPerRoom1_01OrMoreP, format: .percent)
                            DataRow(label: "Median Value", value: latestData.medianValue, comparisonValue: viewModel.latestComparisonHousingData?.medianValue, format: .currency)
                            DataRow(label: "With Mortgage", value: latestData.withMortgageP, comparisonValue: viewModel.latestComparisonHousingData?.withMortgageP, format: .percent)
                            DataRow(label: "Median Monthly Costs (Mortgage)", value: latestData.medianMonthlyOwnerCostsWithMortgage, comparisonValue: viewModel.latestComparisonHousingData?.medianMonthlyOwnerCostsWithMortgage, format: .currency)
                            DataRow(label: "Median Monthly Costs (No Mort.)", value: latestData.medianMonthlyOwnerCostsWithoutMortgage, comparisonValue: viewModel.latestComparisonHousingData?.medianMonthlyOwnerCostsWithoutMortgage, format: .currency)
                            DataRow(label: "Median Gross Rent", value: latestData.medianGrossRent, comparisonValue: viewModel.latestComparisonHousingData?.medianGrossRent, format: .currency)
                            DataRow(label: "Gross Rent > 35% of Income", value: latestData.grossRent35PercentOrMoreP, comparisonValue: viewModel.latestComparisonHousingData?.grossRent35PercentOrMoreP, format: .percent)
                            DataRow(label: "No Vehicles", value: latestData.noVehiclesP, comparisonValue: viewModel.latestComparisonHousingData?.noVehiclesP, format: .percent)
                            DataRow(label: "Utility Gas", value: latestData.utilityGasP, comparisonValue: viewModel.latestComparisonHousingData?.utilityGasP, format: .percent)
                        } else {
                            historicalRow(label: "Total Housing Units", latestValue: latestData.totalHousingUnits, historicalData: viewModel.historicalHousingData, keyPath: \.totalHousingUnits, format: .number)
                            historicalRow(label: "Occupied Housing Units", latestValue: latestData.occupiedHousingUnitsP, historicalData: viewModel.historicalHousingData, keyPath: \.occupiedHousingUnitsP, format: .percent)
                            historicalRow(label: "Vacant Housing Units", latestValue: latestData.vacantHousingUnitsP, historicalData: viewModel.historicalHousingData, keyPath: \.vacantHousingUnitsP, format: .percent)
                            historicalRow(label: "Owner-Occupied", latestValue: latestData.ownerOccupiedP, historicalData: viewModel.historicalHousingData, keyPath: \.ownerOccupiedP, format: .percent)
                            historicalRow(label: "Renter-Occupied", latestValue: latestData.renterOccupiedP, historicalData: viewModel.historicalHousingData, keyPath: \.renterOccupiedP, format: .percent)
                            historicalRow(label: "Avg. Household Size (Owner)", latestValue: latestData.avgHouseholdSizeOwner, historicalData: viewModel.historicalHousingData, keyPath: \.avgHouseholdSizeOwner)
                            historicalRow(label: "Avg. Household Size (Renter)", latestValue: latestData.avgHouseholdSizeRenter, historicalData: viewModel.historicalHousingData, keyPath: \.avgHouseholdSizeRenter)
                            historicalRow(label: "1-Unit, Detached", latestValue: latestData.oneUnitDetachedP, historicalData: viewModel.historicalHousingData, keyPath: \.oneUnitDetachedP, format: .percent)
                            historicalRow(label: "20+ Units", latestValue: latestData.tenOrMoreUnitsP, historicalData: viewModel.historicalHousingData, keyPath: \.tenOrMoreUnitsP, format: .percent)
                            historicalRow(label: "Built 2020 or Later", latestValue: latestData.built2014OrLaterP, historicalData: viewModel.historicalHousingData, keyPath: \.built2014OrLaterP, format: .percent)
                            historicalRow(label: "3 Bedrooms", latestValue: latestData.threeBedroomsP, historicalData: viewModel.historicalHousingData, keyPath: \.threeBedroomsP, format: .percent)
                            historicalRow(label: "Occupants > 1.5/Room", latestValue: latestData.occupantsPerRoom1_01OrMoreP, historicalData: viewModel.historicalHousingData, keyPath: \.occupantsPerRoom1_01OrMoreP, format: .percent)
                            historicalRow(label: "Median Value", latestValue: latestData.medianValue, historicalData: viewModel.historicalHousingData, keyPath: \.medianValue, format: .currency)
                            historicalRow(label: "With Mortgage", latestValue: latestData.withMortgageP, historicalData: viewModel.historicalHousingData, keyPath: \.withMortgageP, format: .percent)
                            historicalRow(label: "Median Monthly Costs (Mortgage)", latestValue: latestData.medianMonthlyOwnerCostsWithMortgage, historicalData: viewModel.historicalHousingData, keyPath: \.medianMonthlyOwnerCostsWithMortgage, format: .currency)
                            historicalRow(label: "Median Monthly Costs (No Mort.)", latestValue: latestData.medianMonthlyOwnerCostsWithoutMortgage, historicalData: viewModel.historicalHousingData, keyPath: \.medianMonthlyOwnerCostsWithoutMortgage, format: .currency)
                            historicalRow(label: "Median Gross Rent", latestValue: latestData.medianGrossRent, historicalData: viewModel.historicalHousingData, keyPath: \.medianGrossRent, format: .currency)
                            historicalRow(label: "Gross Rent > 35% of Income", latestValue: latestData.grossRent35PercentOrMoreP, historicalData: viewModel.historicalHousingData, keyPath: \.grossRent35PercentOrMoreP, format: .percent)
                            historicalRow(label: "No Vehicles", latestValue: latestData.noVehiclesP, historicalData: viewModel.historicalHousingData, keyPath: \.noVehiclesP, format: .percent)
                            historicalRow(label: "Utility Gas", latestValue: latestData.utilityGasP, historicalData: viewModel.historicalHousingData, keyPath: \.utilityGasP, format: .percent)
                        }
                    }
                }
            } else { Text("No data available.") }
        }
    }
    
    private var overviewVisualsContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let latestData = viewModel.latestOverviewData {
                VisualsView(
                    primaryLocationName: location.name,
                    comparisonLocationName: viewModel.comparisonLocationInfo?.name,
                    overviewData: latestData,
                    historicalOverviewData: viewModel.historicalOverviewData,
                    comparisonOverviewData: viewModel.latestComparisonData,
                    historicalComparisonOverviewData: viewModel.historicalComparisonData,
                    demographicData: nil,
                    historicalDemographicData: [:],
                    comparisonDemographicData: nil,
                    historicalComparisonDemographicData: [:],
                    socialData: nil,
                    historicalSocialData: [:],
                    comparisonSocialData: nil,
                    historicalComparisonSocialData: [:],
                    economicData: nil,
                    historicalEconomicData: [:],
                    comparisonEconomicData: nil,
                    historicalComparisonEconomicData: [:],
                    housingData: nil,
                    historicalHousingData: [:],
                    comparisonHousingData: nil,
                    historicalComparisonHousingData: [:],
                    category: category
                )
            } else { Text("No data available to visualize.") }
        }
    }
    
    private var demographicVisualsContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let latestData = viewModel.latestDemographicData {
                VisualsView(
                    primaryLocationName: location.name,
                    comparisonLocationName: viewModel.comparisonLocationInfo?.name,
                    overviewData: nil,
                    historicalOverviewData: [:],
                    comparisonOverviewData: nil,
                    historicalComparisonOverviewData: [:],
                    demographicData: latestData,
                    historicalDemographicData: viewModel.historicalDemographicData,
                    comparisonDemographicData: viewModel.latestComparisonDemographicData,
                    historicalComparisonDemographicData: viewModel.historicalComparisonDemographicData,
                    socialData: nil,
                    historicalSocialData: [:],
                    comparisonSocialData: nil,
                    historicalComparisonSocialData: [:],
                    economicData: nil,
                    historicalEconomicData: [:],
                    comparisonEconomicData: nil,
                    historicalComparisonEconomicData: [:],
                    housingData: nil,
                    historicalHousingData: [:],
                    comparisonHousingData: nil,
                    historicalComparisonHousingData: [:],
                    category: category
                )
            } else { Text("No data available to visualize.") }
        }
    }
    
    private var socialVisualsContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let latestData = viewModel.latestSocialData {
                VisualsView(
                    primaryLocationName: location.name,
                    comparisonLocationName: viewModel.comparisonLocationInfo?.name,
                    overviewData: nil,
                    historicalOverviewData: [:],
                    comparisonOverviewData: nil,
                    historicalComparisonOverviewData: [:],
                    demographicData: nil,
                    historicalDemographicData: [:],
                    comparisonDemographicData: nil,
                    historicalComparisonDemographicData: [:],
                    socialData: latestData,
                    historicalSocialData: viewModel.historicalSocialData,
                    comparisonSocialData: viewModel.latestComparisonSocialData,
                    historicalComparisonSocialData: viewModel.historicalComparisonSocialData,
                    economicData: nil,
                    historicalEconomicData: [:],
                    comparisonEconomicData: nil,
                    historicalComparisonEconomicData: [:],
                    housingData: nil,
                    historicalHousingData: [:],
                    comparisonHousingData: nil,
                    historicalComparisonHousingData: [:],
                    category: category
                )
            } else { Text("No data available to visualize.") }
        }
    }
    
    private var economicVisualsContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let latestData = viewModel.latestEconomicData {
                VisualsView(
                    primaryLocationName: location.name,
                    comparisonLocationName: viewModel.comparisonLocationInfo?.name,
                    overviewData: nil,
                    historicalOverviewData: [:],
                    comparisonOverviewData: nil,
                    historicalComparisonOverviewData: [:],
                    demographicData: nil,
                    historicalDemographicData: [:],
                    comparisonDemographicData: nil,
                    historicalComparisonDemographicData: [:],
                    socialData: nil,
                    historicalSocialData: [:],
                    comparisonSocialData: nil,
                    historicalComparisonSocialData: [:],
                    economicData: latestData,
                    historicalEconomicData: viewModel.historicalEconomicData,
                    comparisonEconomicData: viewModel.latestComparisonEconomicData,
                    historicalComparisonEconomicData: viewModel.historicalComparisonEconomicData,
                    housingData: nil,
                    historicalHousingData: [:],
                    comparisonHousingData: nil,
                    historicalComparisonHousingData: [:],
                    category: category
                )
            } else { Text("No data available to visualize.") }
        }
    }
    
    private var housingVisualsContent: some View {
        Group {
            if viewModel.isLoading { ProgressView("Loading Data...") }
            else if let latestData = viewModel.latestHousingData {
                VisualsView(
                    primaryLocationName: location.name,
                    comparisonLocationName: viewModel.comparisonLocationInfo?.name,
                    overviewData: nil,
                    historicalOverviewData: [:],
                    comparisonOverviewData: nil,
                    historicalComparisonOverviewData: [:],
                    demographicData: nil,
                    historicalDemographicData: [:],
                    comparisonDemographicData: nil,
                    historicalComparisonDemographicData: [:],
                    socialData: nil,
                    historicalSocialData: [:],
                    comparisonSocialData: nil,
                    historicalComparisonSocialData: [:],
                    economicData: nil,
                    historicalEconomicData: [:],
                    comparisonEconomicData: nil,
                    historicalComparisonEconomicData: [:],
                    housingData: latestData,
                    historicalHousingData: viewModel.historicalHousingData,
                    comparisonHousingData: viewModel.latestComparisonHousingData,
                    historicalComparisonHousingData: viewModel.historicalComparisonHousingData,
                    category: category
                )
            } else { Text("No data available to visualize.") }
        }
    }
    
    private var comparisonHeaderView: some View {
        HStack {
            Text("Metric").fontWeight(.bold)
            Spacer()
            Text(location.name).fontWeight(.bold).frame(width: 100, alignment: .trailing)
            if viewModel.isComparing {
                Text(viewModel.comparisonLocationInfo?.name ?? "Comparison").fontWeight(.bold).frame(width: 100, alignment: .trailing)
            }
        }.font(.caption)
    }
    
    private var historicalHeaderView: some View {
        HStack {
            Text("Metric").fontWeight(.bold)
            Spacer()
            Text("2023").fontWeight(.bold).frame(width: 100, alignment: .trailing)
            ForEach(sortedHistoricalYears, id: \.self) { year in
                Text(year).fontWeight(.bold).frame(width: 100, alignment: .trailing)
            }
        }.font(.caption)
    }
    
    @ViewBuilder
    private func historicalRow<T>(label: String, latestValue: String?, historicalData: [String: T], keyPath: KeyPath<T, String?>, format: DataRow.Format? = nil) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(formattedValue(for: latestValue, format: format))
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .trailing)
            ForEach(sortedHistoricalYears, id: \.self) { year in
                let value = historicalData[year]?[keyPath: keyPath]
                Text(formattedValue(for: value, format: format))
                    .fontWeight(.semibold)
                    .frame(width: 100, alignment: .trailing)
            }
        }
    }
    
    private func formattedValue(for value: String?, format: DataRow.Format?) -> String {
        guard let value = value, let doubleValue = Double(value) else { return "N/A" }
        let formatter = NumberFormatter()
        switch format {
        case .number:
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        case .currency:
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        case .percent:
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: doubleValue / 100.0)) ?? "N/A"
        case .none:
            return String(format: "%.1f", doubleValue)
        }
    }
}

struct DataRow: View {
    enum Format { case number, currency, percent }
    
    let label: String
    let value: String?
    let comparisonValue: String?
    var format: Format? = nil
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(formattedValue(for: value))
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .trailing)
            
            if let comparison = comparisonValue {
                Text(formattedValue(for: comparison))
                    .fontWeight(.semibold)
                    .frame(width: 100, alignment: .trailing)
            }
        }
    }
    
    private func formattedValue(for value: String?) -> String {
        guard let value = value, let doubleValue = Double(value) else { return "N/A" }
        let formatter = NumberFormatter()
        switch format {
        case .number:
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        case .currency:
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        case .percent:
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: doubleValue / 100.0)) ?? "N/A"
        case .none:
            return String(format: "%.1f", doubleValue)
        }
    }
}
