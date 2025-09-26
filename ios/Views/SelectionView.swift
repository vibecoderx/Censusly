//
// File: SelectionView.swift (MODIFIED)
//

import SwiftUI

struct SelectionView: View {
    @StateObject private var viewModel = SelectionViewModel()
    
    enum GeoLevel: String, CaseIterable, Identifiable {
        case usa = "USA"
        case state = "State"
        case county = "County"
        case city = "City"
        case zip = "Zip Code"
        var id: Self { self }
    }

    @State private var selectedLevel: GeoLevel = .usa
    @State private var selectedStateFips: String = "36" // Default NY
    @State private var selectedCountyFips: String = ""
    @State private var selectedPlace: Place?
    @State private var zipCode: String = ""

    private var locationInfo: (level: GeoLevel, name: String, fips: String) {
        switch selectedLevel {
        case .usa:
            return (level: .usa, name: "United States", fips: "1")
        case .state:
            let name = viewModel.states.first { $0.fips == selectedStateFips }?.name ?? ""
            return (level: .state, name: name, fips: selectedStateFips)
        case .county:
            let name = viewModel.counties.first { $0.fips == selectedCountyFips }?.name ?? ""
            return (level: .county, name: name, fips: selectedCountyFips)
        case .city:
            return (level: .city, name: selectedPlace?.name ?? "", fips: selectedPlace?.fips ?? "")
        case .zip:
            // FIX: The zip code itself is used as both the name and the FIPS identifier for the API call.
            return (level: .zip, name: zipCode, fips: zipCode)
        }
    }

    var body: some View {
        VStack {
            Text("Censusly")
                .font(.largeTitle).fontWeight(.bold).padding(.bottom, 40)

            Picker("Select Geographic Level", selection: $selectedLevel) {
                ForEach(GeoLevel.allCases) { Text($0.rawValue) }
            }.pickerStyle(.segmented).padding(.horizontal)

            formContent
            
            NavigationLink(destination: CategorySelectionView(
                location: locationInfo,
                stateFips: selectedStateFips
            )) {
                Text("Show Data")
                    .font(.headline).foregroundColor(.white).padding()
                    .frame(maxWidth: .infinity).background(Color.blue).cornerRadius(10)
            }
            .padding()
            .disabled(viewModel.isLoadingStates || viewModel.isLoadingCounties || viewModel.isLoadingPlaces)

            Spacer()
        }
        // .navigationTitle("Select Area").navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var formContent: some View {
        if selectedLevel == .city {
            VStack {
                stateSelectionPicker.padding(.horizontal)
                citySelectionSection.padding(.horizontal)
            }
        } else {
            Form {
                switch selectedLevel {
                case .state, .county:
                    stateSelectionSection
                case .zip:
                    TextField("Zip Code", text: $zipCode).keyboardType(.numberPad)
                case .usa:
                    EmptyView()
                case .city:
                    EmptyView()
                }
            }
            .frame(height: selectedLevel == .usa ? 0 : 150)
            .cornerRadius(10)
        }
    }
    
    private var stateSelectionSection: some View {
        Group {
            stateSelectionPicker
            
            if selectedLevel == .county {
                countySelectionSection
            }
        }
    }
    
    private var stateSelectionPicker: some View {
        Group {
            if viewModel.isLoadingStates {
                HStack { Spacer(); ProgressView("Loading States..."); Spacer() }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                Picker("State", selection: $selectedStateFips) {
                    ForEach(viewModel.states) { state in
                        Text(state.name).tag(state.fips)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchStatesIfNeeded()
        }
        .onChange(of: selectedStateFips) {
            if selectedLevel == .county {
                viewModel.fetchCounties(forStateFips: selectedStateFips)
            } else if selectedLevel == .city {
                viewModel.fetchPlaces(forStateFips: selectedStateFips)
            }
        }
    }
    
    private var countySelectionSection: some View {
        Group {
            if viewModel.isLoadingCounties {
                HStack { Spacer(); ProgressView("Loading Counties..."); Spacer() }
            } else if !viewModel.counties.isEmpty {
                Picker("County", selection: $selectedCountyFips) {
                    ForEach(viewModel.counties) { county in
                        Text(county.name).tag(county.fips)
                    }
                }
            } else {
                Text("Select a state to see counties.").foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.fetchCounties(forStateFips: selectedStateFips)
        }
    }
    
    private var citySelectionSection: some View {
        VStack {
            TextField("Search for a city...", text: $viewModel.citySearchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 5)
                .disabled(viewModel.isLoadingPlaces)

            if viewModel.isLoadingPlaces {
                ProgressView("Loading Cities...")
            } else {
                List(viewModel.filteredPlaces) { place in
                    Button(action: {
                        self.selectedPlace = place
                        viewModel.citySearchText = place.name
                    }) {
                        Text(place.name)
                            .foregroundColor(selectedPlace == place ? .white : .primary)
                    }
                    .listRowBackground(selectedPlace == place ? Color.blue : Color.clear)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            viewModel.fetchPlaces(forStateFips: selectedStateFips)
        }
    }
}
