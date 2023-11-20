import SwiftUI
import HealthKit

struct BarChart: View {
    let data: [Date: Int]

    var body: some View {
        VStack {
            Text("Weekly Step Counts")
                .font(.title)

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(Array(data.keys.sorted(by: <)), id: \.self) { date in
                        VStack {
                            Text("\(date, formatter: dateFormatter)")
                                .rotationEffect(.degrees(-45), anchor: .bottom)
                                .font(.caption)

                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: CGFloat(data[date]!))
                        }
                    }
                }
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
}
