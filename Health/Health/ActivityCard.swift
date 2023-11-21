import SwiftUI
struct Activity{
    let id:Int
    let title:String
    let subtitle:String
    let image:String
    let amount:String
}
struct ActivityCard: View {
    @State private var weeklyStepCounts: [Date: Int] = [:]
    @State var activity: Activity
    @State private var isDetailViewPresented = false 
    @EnvironmentObject var manager : HealthManager
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 30, height: 30), style: .continuous)
                        .frame(width: 300)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            isDetailViewPresented.toggle()
                        }
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(activity.title + ":")
                                    .font(.title)
                                Text(activity.amount)
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                                Image(systemName: activity.image)
                                    .foregroundColor(.red)
                            }
                            Text(activity.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .padding()
                        }
                        if(activity.id==0){
                            ChartView(selectedCharter: .oneWeek).frame(width:100,height: 150).scaledToFit()
                        }
                        if(activity.id==1){
                            CaloriesChartView().frame(width:100,height: 150).scaledToFit()
                        }
                    }
                }
            }
        }.scaledToFill()
        .fullScreenCover(isPresented: $isDetailViewPresented) {

            if activity.id==0{

                    StepsView(activity: activity)

            }
            if activity.id==1{
                CaloriesView(activity: activity)
            }
            if activity.id==2{
                sleepView(activity: activity)
            }
        }
    }
}


#Preview {
    HomeView()
}
