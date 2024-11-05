//
//  VycleLiveWidget.swift
//  VycleLiveWidget
//
//  Created by Vincent Senjaya on 05/11/24.
//

import WidgetKit
import SwiftUI



struct VycleLiveWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BeaconAttribute.self) { context in
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    HStack {
                        Image("imagetest")
                           .resizable()
                           .frame(width: 38, height: 38)
                           .clipShape(RoundedRectangle(cornerRadius: 8))
        
                        Spacer()
                        
                        VStack{
                            Text("Status VBeacon")
                                .font(.system(size: 20))
                                .bold()
                            HStack{
                                Image("bt_icon")
                                   .resizable()
                                   .frame(width: 20, height: 20)
                                Text("Terhubung")
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color.royalblue)
                                    .bold()
                                    
                            }
                        }
                    }
                }
                
            }
            .padding()
            .frame(height: 90)
            .background(.black)
            
           
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                       
                        
                        
                        
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image("imagetest")
                           .resizable()
                           .frame(width: 60, height: 60)
                           .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                        VStack{
                            Text("Status VBeacon")
                                .font(.system(size: 20))
                                .bold()
                            HStack{
                                Image("bt_icon")
                                   .resizable()
                                   .frame(width: 20, height: 20)
                                Text("Terhubung")
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color.royalblue)
                                    .bold()
                                    
                            }
                        }
//                            Text("~ \(context.state.connectionStatus)")
//                                .font(.system(size: 14))
//                                .bold()
                    }
                    .padding(.bottom, 15)
                }
            } compactLeading: {
                Image("imagetest")
                   .resizable()
                   .frame(width: 20, height: 20)
                   .clipShape(RoundedRectangle(cornerRadius: 8))
            } compactTrailing: {
                
            } minimal: {
                Image("imagetest")
                   .resizable()
                   .frame(width: 20, height: 20)
                   .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    
    
}
