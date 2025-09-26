//
// File: VisualizationCard.swift (MODIFIED)
// Folder: Views/Visualizations
//

import SwiftUI
import Charts

struct VisualizationCard<T>: View {
    let title: String
    let latestValue: String?
    let historicalData: [String: Any]
    let latestComparisonValue: String?
    let historicalComparisonData: [String: Any]
    let keyPath: KeyPath<T, String?>
    let format: DataRow.Format?

    private var shouldShowTrendChart: Bool {
        !historicalData.isEmpty || !historicalComparisonData.isEmpty
    }
    
    private var chartData: [ChartDataPoint] {
        var dataPoints: [ChartDataPoint] = []
        
        if let latest = latestValue, let val = Double(latest) {
            dataPoints.append(ChartDataPoint(year: "Latest", value: val, location: "Primary"))
        }
        for (year, data) in historicalData {
            if let data = data as? T, let strVal = data[keyPath: keyPath], let val = Double(strVal) {
                dataPoints.append(ChartDataPoint(year: year, value: val, location: "Primary"))
            }
        }
        
        if let latest = latestComparisonValue, let val = Double(latest) {
            dataPoints.append(ChartDataPoint(year: "Latest", value: val, location: "Comparison"))
        }
        for (year, data) in historicalComparisonData {
            if let data = data as? T, let strVal = data[keyPath: keyPath], let val = Double(strVal) {
                dataPoints.append(ChartDataPoint(year: year, value: val, location: "Comparison"))
            }
        }
        
        return dataPoints.sorted {
            if $1.year == "Latest" { return true }
            if $0.year == "Latest" { return false }
            return $0.year < $1.year
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline).foregroundColor(.secondary)
            
            Spacer()
            
            if shouldShowTrendChart {
                LineChartView(data: chartData, format: format)
            } else {
                snapshotContent
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .frame(height: 220)
    }
    
    @ViewBuilder
    private var snapshotContent: some View {
        if format == .percent {
            HStack {
                GaugeView(value: latestValue)
                if let comparisonValue = latestComparisonValue {
                    GaugeView(value: comparisonValue, color: .green)
                }
            }
        } else {
            LargeNumberView(
                value: latestValue,
                comparisonValue: latestComparisonValue,
                format: format
            )
        }
    }
}
