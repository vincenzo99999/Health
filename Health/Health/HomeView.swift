import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager

    let gridItemLayout = [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)]

    var body: some View {
        VStack {
            LazyHGrid(rows: gridItemLayout, spacing: 15) {
                ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                    ActivityCard(activity: item.value)
                }
            }
            .padding(15)
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
