import SwiftUI
struct Activity{
    let id:Int
    let title:String
    let subtitle:String
    let image:String
    let amount:String
}
struct ActivityCard:View {
    @State var activity:Activity
    var body: some View {
        VStack{
            HStack(alignment: .top,spacing:5)
            {
                ZStack{
                    
                    RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).frame(width:350,height: 200).foregroundColor(.gray).padding()

                    HStack(alignment:.top) {
                        VStack{
                            HStack{
                                Text(activity.title+":").font(.title)
                                Text(activity.amount).font(.title).foregroundColor(.black
                                ).padding()
                                Image(systemName:activity.image).foregroundColor(.red)

                            }
                                Text(activity.subtitle).font(.subheadline).foregroundColor(.black
                                ).padding()

                            }
                            

                    }
                }
                
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity,alignment: .leading).padding()
            Spacer()

            
            
        }
            .padding()
    }
}
#Preview {
    HomeView()
}
