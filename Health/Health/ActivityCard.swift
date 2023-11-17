import SwiftUI
struct Activity{
    let id:Int
    let title:String
    let subtitle:String
    let image:String
    let amount:String
}
struct ActivityCard: View {
    @State var activity: Activity
    @State private var isDetailViewPresented = false 
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 30, height: 30), style: .continuous)
                        .frame(width: 300)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            isDetailViewPresented.toggle() // Attiva il flag quando l'utente tocca la card
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
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isDetailViewPresented) {
            if activity.id==0{
                stepsView(activity: activity)
            }
            if activity.id==1{
                caloriesView(activity: activity)
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
