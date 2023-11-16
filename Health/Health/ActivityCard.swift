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
                    
                        Text(activity.title).font(.system(size: 16)).padding(30)
                        Spacer()
                        Text(activity.amount).font(.system(size:12)).foregroundColor(.black
                            ).padding()
                        Image(activity.image).foregroundColor(.blue).padding(30)
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
