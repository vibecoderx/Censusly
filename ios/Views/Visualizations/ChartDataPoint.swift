//
// File: ChartDataPoint.swift (MODIFIED)
// Folder: Views/Visualizations
//

import SwiftUI
import Charts

// A simple data structure for the line chart.
struct ChartDataPoint: Identifiable {
    var id = UUID()
    let year: String
    let value: Double
    let location: String // "Primary" or "Comparison"
}

// MARK: - Line Chart View
struct LineChartView: View {
    let data: [ChartDataPoint]
    let format: DataRow.Format?

    private var yAxisDomain: ClosedRange<Double> {
        let values = data.map { $0.value }
        guard let minValue = values.min(), let maxValue = values.max() else { return 0...1 }
        if minValue == maxValue { return (minValue - 1)...(maxValue + 1) }
        let padding = (maxValue - minValue) * 1.0
        return (minValue - padding)...(maxValue + padding)
    }

    var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value("Year", point.year),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Location", point.location))
            .interpolationMethod(.catmullRom)
            
            PointMark(
                x: .value("Year", point.year),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Location", point.location))
            // FIX: Added an annotation to each point to display its value.
            .annotation(position: .top) {
                Text(formattedValue(for: point.value))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .chartForegroundStyleScale([
            "Primary": .blue,
            "Comparison": .green
        ])
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                if format == .percent {
                    AxisValueLabel("\(value.as(Double.self) ?? 0, specifier: "%.0f")%")
                } else if format == .currency {
                     AxisValueLabel(format: .currency(code: "USD").precision(.significantDigits(2)))
                } else {
                    AxisValueLabel()
                }
            }
        }
        .chartYScale(domain: yAxisDomain)
        .chartLegend(.hidden)
    }
    
    private func formattedValue(for value: Double) -> String {
        switch format {
        case .currency: return String(format: "$%.0f", value)
        case .percent: return String(format: "%.1f%%", value)
        default: return String(format: "%.1f", value)
        }
    }
}

// MARK: - Gauge View
struct GaugeView: View {
    let value: String?
    var color: Color = .blue
    
    private var percentage: Double {
        guard let value = value, let doubleValue = Double(value) else { return 0 }
        return doubleValue / 100.0
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.1)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: percentage)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
            
            Text(String(format: "%.1f%%", percentage * 100))
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

// MARK: - Large Number View
struct LargeNumberView: View {
    let value: String?
    let comparisonValue: String?
    let format: DataRow.Format?
    
    private func formattedValue(for stringValue: String?) -> String {
        guard let stringValue = stringValue, let doubleValue = Double(stringValue) else { return "N/A" }
        let formatter = NumberFormatter()
        switch format {
        case .number:
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        case .currency:
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: doubleValue)) ?? "N/A"
        default:
            return stringValue
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            if let comparison = comparisonValue {
                VStack {
                    Text(formattedValue(for: value))
                        .font(.title).fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("vs")
                        .font(.caption).foregroundColor(.secondary)
                    Text(formattedValue(for: comparison))
                        .font(.title).fontWeight(.bold)
                        .foregroundColor(.green)
                }
            } else {
                Text(formattedValue(for: value))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
    }
}
