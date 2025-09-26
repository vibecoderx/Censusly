//
// File: SelectionViewModel.swift (MODIFIED)
//

import Foundation
import Combine

@MainActor
class SelectionViewModel: ObservableObject {
    @Published var states: [USState] = []
    @Published var counties: [County] = []
    
    // Properties for managing the city/place search.
    @Published private var allPlaces: [Place] = []
    @Published var filteredPlaces: [Place] = []
    @Published var citySearchText = ""
    
    @Published var isLoadingStates = false
    @Published var isLoadingCounties = false
    @Published var isLoadingPlaces = false
    
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = CensusAPIService()
    
    init() {
        // A Combine pipeline to filter places based on the search text.
        $citySearchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] searchText -> [Place] in
                guard let self = self else { return [] }
                if searchText.isEmpty {
                    // If search is empty, show a limited number of initial results.
                    return Array(self.allPlaces.prefix(20))
                } else {
                    // Otherwise, filter the full list.
                    return self.allPlaces.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                }
            }
            .assign(to: \.filteredPlaces, on: self)
            .store(in: &cancellables)
    }

    func fetchStatesIfNeeded() {
        guard states.isEmpty else { return }
        isLoadingStates = true
        errorMessage = nil
        Task {
            do {
                let fetchedStates = try await apiService.fetchStates()
                self.states = fetchedStates.map {
                    let abbreviation = StateAbbreviationHelper.abbreviation(for: $0.name) ?? $0.name
                    return USState(name: abbreviation, fips: $0.fips)
                }.sorted { $0.name < $1.name }
            } catch { self.errorMessage = "Failed to load states." }
            isLoadingStates = false
        }
    }
    
    func fetchCounties(forStateFips stateFips: String) {
        counties = []
        isLoadingCounties = true
        errorMessage = nil
        Task {
            do {
                self.counties = try await apiService.fetchCounties(forStateFips: stateFips).sorted { $0.name < $1.name }
            } catch { self.errorMessage = "Failed to load counties." }
            isLoadingCounties = false
        }
    }
    
    /**
     Fetches the list of all places (cities) for a given state FIPS code.
     */
    func fetchPlaces(forStateFips stateFips: String) {
        allPlaces = []
        isLoadingPlaces = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedPlaces = try await apiService.fetchPlaces(forStateFips: stateFips)
                self.allPlaces = fetchedPlaces.sorted { $0.name < $1.name }
            } catch {
                self.errorMessage = "Failed to load cities for the selected state."
            }
            isLoadingPlaces = false
        }
    }
}
