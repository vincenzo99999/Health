import SwiftUI
struct Activity{
    let id:Int
    let title:String
    let subtitle:String
    let image:String
    let amount:String
    let color:Color?
}
struct ActivityCard: View {
    @State private var weeklyStepCounts: [Date: Int] = [:]
    @State var activity: Activity
    @State private var isDetailViewPresented = false
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 20.0).frame(width: 380,height:100).foregroundColor(.white)                .onTapGesture
            {
                isDetailViewPresented.toggle()
            }
            HStack{
                VStack(alignment: .leading) {
                    HStack {
                        VStack{
                            
                
                            Image(systemName:activity.image).foregroundColor(activity.color)
                                .padding()
                            Spacer().frame(height:40)
                            Text(activity.title)
                                .font(.subheadline)
                                .foregroundStyle(.gray).opacity(0.8).padding(.leading,50)
                            Text(activity.amount).font(.title)
                        }.frame(minWidth: 150).padding(.leading, (activity.id == 1 || activity.id == 0 ) ? 50 : 150)
                        Spacer(minLength: 10).frame(width: 100)
                        if(activity.id==0){
                            ChartView(selectedCharter: .oneWeek).scaledToFill().padding(.trailing,30)
                        }
                        if(activity.id==1){
                            CaloriesChartView().scaledToFill().padding(.trailing,30)
                            
                        }
                        if (activity.id==2){
                            Image("bedGraph").resizable().frame(width: 100,height: 100).scaledToFill().padding(.trailing,200)
                        }
                        if(activity.id==4){
                            Image("audioExposureGraph").resizable().frame(width: 100,height: 100).scaledToFill().padding(.trailing,200)
                        }
                    }
                }
            }.scaledToFit()
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
}
#Preview {
    HomeView()
}
