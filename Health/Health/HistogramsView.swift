import SwiftUI

struct WeeklyHistogramView: View {
    @EnvironmentObject var manager: HealthManager

    var body: some View {
        VStack {
            Text("Weekly Steps")
                .font(.title)
                .padding()

            BarChartView(data: manager.weeklyStepsData)
                .padding()
        }
    }
}

struct BarChartView: View {
    let data: [Double]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(data, id: \.self) { value in
                BarView(value: value)
            }
        }
    }
}

struct BarView: View {
    let value: Double

    var body: some View {
        VStack {
            Text(String(format: "%.0f", value))
                .foregroundColor(.white)
            Rectangle()
                .fill(Color.blue)
                .frame(height: CGFloat(value))
        }
    }
}
