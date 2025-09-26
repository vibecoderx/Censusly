//
// File: CensusAPIService.swift (MODIFIED)
//

import Foundation

class CensusAPIService {
    
    // Using the 5-year ACS data for broader geography coverage, including smaller places.
    private let acsBaseURL = "https://api.census.gov/data/2022/acs/acs5"
    private let profileBaseURL = "https://api.census.gov/data/2023/acs/acs5/profile"
    
    private let overviewVariables = [
        "DP05_0001E", "DP05_0018E", "DP03_0062E", "DP02_0067PE",
        "DP03_0119PE", "DP04_0046PE", "DP03_0025E", "DP04_0089E", "DP03_0009PE",
        "DP02_0094E", "DP02_0070E", "DP02_0153PE", "DP02_0068PE", "DP04_0134E"
    ].joined(separator: ",")
    
    private let demographicVariables = [
        "DP05_0001E", "DP05_0002E", "DP05_0003E", "DP05_0018E", "DP05_0019E",
        "DP05_0024E", "DP05_0037PE", "DP05_0038PE", "DP05_0039PE", "DP05_0047PE",
        "DP05_0055PE", "DP05_0034PE", "DP05_0061PE", "DP05_0076PE", "DP05_0082PE",
        "DP05_0004E", "DP02_0090PE", "DP05_0022PE", "DP05_0021PE", "DP02_0113PE"
    ].joined(separator: ",")
    
    private let socialVariables = [
        "DP02_0001E", "DP02_0014PE", "DP02_0015PE", "DP02_0016E", "DP02_0004PE",
        "DP02_0017E", "DP02_0002PE", "DP02_0057PE", "DP02_0067PE", "DP02_0068PE",
        "DP02_0072PE", "DP02_0070PE", "DP02_0114PE", "DP02_0153PE", "DP02_0154PE",
        "DP02_0038PE", "DP02_0094PE", "DP02_0090PE", "DP02_0045PE", "DP02_0125PE"
    ].joined(separator: ",")
    
    private let economicVariables = [
        "DP03_0004PE", "DP03_0009PE", "DP03_0025E", "DP03_0027PE", "DP03_0030PE",
        "DP03_0042PE", "DP03_0048PE", "DP03_0088E", "DP03_0062E", "DP03_0063E",        
        "DP03_0066PE", "DP03_0074PE", "DP03_0096PE", "DP03_0097PE", "DP03_0098PE",
        "DP03_0119PE", "DP03_0019PE", "DP03_0020PE", "DP03_0021PE", "DP03_0022PE"
    ].joined(separator: ",")
    
    private let housingVariables = [
        "DP04_0001E", "DP04_0002PE", "DP04_0003PE", "DP04_0046PE", "DP04_0047PE",
        "DP04_0048E", "DP04_0049E", "DP04_0007PE", "DP04_0013PE", "DP04_0017PE",
        "DP04_0042PE", "DP04_0079PE", "DP04_0089E", "DP04_0091PE", "DP04_0101E",
        "DP04_0109E", "DP04_0134E", "DP04_0142PE", "DP04_0058PE", "DP04_0063PE"
    ].joined(separator: ",")

    func fetchHistoricalOverviewData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String) async throws -> OverviewData {
        let data = try await fetchHistoricalData(for: location, stateFips: stateFips, year: year, variables: overviewVariables)
        return OverviewData(apiData: data)
    }
    
    func fetchHistoricalDemographicData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String) async throws -> DemographicData {
        let data = try await fetchHistoricalData(for: location, stateFips: stateFips, year: year, variables: demographicVariables)
        return DemographicData(apiData: data)
    }
    
    func fetchHistoricalSocialData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String) async throws -> SocialData {
        let data = try await fetchHistoricalData(for: location, stateFips: stateFips, year: year, variables: socialVariables)
        return SocialData(apiData: data)
    }
    
    func fetchHistoricalEconomicData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String) async throws -> EconomicData {
        let data = try await fetchHistoricalData(for: location, stateFips: stateFips, year: year, variables: economicVariables)
        return EconomicData(apiData: data)
    }
    
    func fetchHistoricalHousingData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String) async throws -> HousingData {
        let data = try await fetchHistoricalData(for: location, stateFips: stateFips, year: year, variables: housingVariables)
        return HousingData(apiData: data)
    }

    func fetchLatestOverviewData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String) async throws -> OverviewData {
        return try await fetchHistoricalOverviewData(for: location, stateFips: stateFips, year: "2023")
    }
    
    func fetchLatestDemographicData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String) async throws -> DemographicData {
        return try await fetchHistoricalDemographicData(for: location, stateFips: stateFips, year: "2023")
    }
    
    func fetchLatestSocialData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String) async throws -> SocialData {
        return try await fetchHistoricalSocialData(for: location, stateFips: stateFips, year: "2023")
    }
    
    func fetchLatestEconomicData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String) async throws -> EconomicData {
        return try await fetchHistoricalEconomicData(for: location, stateFips: stateFips, year: "2023")
    }
    
    func fetchLatestHousingData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String) async throws -> HousingData {
        return try await fetchHistoricalHousingData(for: location, stateFips: stateFips, year: "2023")
    }
    
    private func fetchHistoricalData(for location: (level: SelectionView.GeoLevel, name: String, fips: String), stateFips: String, year: String, variables: String) async throws -> [String] {
        let profileBaseURL = "https://api.census.gov/data/\(year)/acs/acs5/profile"
        var components = URLComponents(string: profileBaseURL)!
        var queryItems = [URLQueryItem(name: "get", value: variables)]
        
        switch location.level {
        case .usa:
            queryItems.append(URLQueryItem(name: "for", value: "us:1"))
        case .state:
            queryItems.append(URLQueryItem(name: "for", value: "state:\(stateFips)"))
        case .county:
            queryItems.append(URLQueryItem(name: "for", value: "county:\(location.fips)"))
            queryItems.append(URLQueryItem(name: "in", value: "state:\(stateFips)"))
        case .city:
            queryItems.append(URLQueryItem(name: "for", value: "place:\(location.fips)"))
            queryItems.append(URLQueryItem(name: "in", value: "state:\(stateFips)"))
        case .zip:
            queryItems.append(URLQueryItem(name: "for", value: "zip code tabulation area:\(location.fips)"))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode([[String]].self, from: data)
        
        guard decodedData.count > 1, let dataRow = decodedData.last else {
            throw URLError(.cannotParseResponse)
        }
        
        return dataRow
    }

    func fetchStates() async throws -> [USState] {
        let urlString = "\(acsBaseURL)?get=NAME&for=state:*"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode([[String]].self, from: data)
        let states = decodedData.dropFirst().compactMap { USState(name: $0[0], fips: $0[1]) }
        return states
    }
    
    func fetchCounties(forStateFips stateFips: String) async throws -> [County] {
        let urlString = "\(acsBaseURL)?get=NAME&for=county:*&in=state:\(stateFips)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode([[String]].self, from: data)
        let counties = decodedData.dropFirst().compactMap { row -> County? in
            guard row.count == 3 else { return nil }
            let cleanedName = row[0].components(separatedBy: ",").first ?? row[0]
            return County(name: cleanedName, fips: row[2])
        }
        return counties
    }
    
    func fetchPlaces(forStateFips stateFips: String) async throws -> [Place] {
        let urlString = "\(acsBaseURL)?get=NAME&for=place:*&in=state:\(stateFips)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode([[String]].self, from: data)
        
        let places = decodedData.dropFirst().compactMap { row -> Place? in
            guard row.count == 3 else { return nil }
            var cleanedName = row[0].components(separatedBy: ",").first ?? row[0]
            let suffixesToRemove = [" city", " CDP", " borough", " town", " village"]
            for suffix in suffixesToRemove {
                if cleanedName.hasSuffix(suffix) {
                    cleanedName = cleanedName.replacingOccurrences(of: suffix, with: "")
                }
            }
            return Place(name: cleanedName.trimmingCharacters(in: .whitespaces), fips: row[2])
        }
        
        return places
    }
}
