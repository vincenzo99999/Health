
import Foundation
import SwiftUI
struct sleepView:View{
    @EnvironmentObject var manager: HealthManager
    @Environment (\.dismiss) private var dismiss
    
    var activity: Activity
    
    var body: some View {
        VStack {
            HStack{
                
                Button(action: {
                    dismiss()
                }){
                label: do {
                    Image(systemName: "chevron.backward").foregroundStyle(.black).font(.system(size: 30))
                        .frame(width: 35, height: 35)
                    Spacer()
                }}
            }
            ZStack{
                Rectangle().frame(width: 400,height: 500)
                VStack{
                    HStack{
                        
                        Text("Dettagli attività: \(activity.title)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        Image(systemName:activity.image).foregroundColor(.red)
                    }
                    HStack{
                        Text("\(activity.amount)\t").foregroundColor(.white)
                        Text("\(activity.subtitle)").foregroundColor(.white)
                    }
                }
                
            }
        }
    }
}
