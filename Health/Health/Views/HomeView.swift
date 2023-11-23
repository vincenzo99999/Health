import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    
    
    
    var body: some View {
        NavigationStack{
            List(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                ActivityCard(activity: item.value)
                }
            .listRowSpacing(15)
                .navigationTitle("Summary")
                .toolbar{
                    Button(action: {}){
                        Text("Edit")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }

#Preview {
    HomeView()
}
