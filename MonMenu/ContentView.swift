//
//  ContentView.swift
//  MonMenu
//
//  Created by Robert Grizzard on 2/22/20.
//  Copyright © 2020 Robert Grizzard. All rights reserved.
//

import SwiftUI
import SwiftUIFontIcon



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @ObservedObject var CpuPercent = CpuUpdateModel.init()
    @ObservedObject var my_BG_T = Background_Timer()
    @State var progressValue: Float = 50.0
    let observer = ActivityObserver()
    
    
    
    let sayi: Int = 5
    
    var body: some View {
        /*VStack {
            Text("CPU Temp: \(my_BG_T.cpu_Temp_copy) °C").frame(minWidth: 200, idealWidth: 600, maxWidth: .infinity, minHeight: 200, idealHeight: 400, maxHeight: .infinity, alignment: .center)
        }*/
        
        VStack (spacing: 5.0) {
                    HStack{
                        
                        //// CPU

                        HStack {
                            /*Text("CPU: \(my_BG_T.cpu_usage)%")
                                .padding()
                           ProgressBar(progress: self.$progressValue)
                                .frame(width: 50.0, height: 50.0)
                                .padding(20.0).onAppear(){
                                    self.progressValue = Float(my_BG_T.cpu_usage)/80*1.002
                                }*/
                            
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 8.0)
                                        .opacity(0.20)
                                        .foregroundColor(Color.gray)
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(min(Float(my_BG_T.cpu_usage)/100*1.002, 1.0)))
                                         .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
                                         .foregroundColor(Color.green)
                                         .rotationEffect(Angle(degrees: 270))
                                         .animation(.easeInOut(duration: 1.0))
                                    FontIcon.text(.materialIcon(code: .memory))
                                        .padding(.bottom, 15)
                                        .padding(.leading, 2)
                                    Text("CPU")
                                        .font(.system(size: 10))
                                        .padding(.top, 20)
                                        .padding(.leading, 3)

                                }
                                .frame(width: 55.0, height: 55.0)
                                .padding(0.0).onAppear(){
                                    self.progressValue = Float(my_BG_T.cpu_usage)/100*1.002
                                }
                            
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                        
                        ///MEMORY
                        
                        
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 8.0)
                                    .opacity(0.20)
                                    .foregroundColor(Color.gray)
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min((Float(my_BG_T.memory_usage) )/100*1.002, 1.0)))
                                     .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
                                     .foregroundColor(Color.green)
                                     .rotationEffect(Angle(degrees: 270))
                                     .animation(.easeInOut(duration: 1.0))
                                FontIcon.text(.awesome5Solid(code: .memory), fontsize: 14)
                                    .padding(.bottom, 15)
                                    .padding(.leading, 1.5)
                                Text("MEM")
                                    .font(.system(size: 10))
                                    .padding(.top, 20)
                                    .padding(.leading, 3)
                                
                                        

                            }
                            .frame(width: 55.0, height: 55.0)
                            .padding(0).onAppear(){
                                self.progressValue = (Float(my_BG_T.memory_usage) )/100*1.002
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 8.0)
                                    .opacity(0.20)
                                    .foregroundColor(Color.gray)
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min((Float(my_BG_T.disk_usage) )/100*1.002, 1.0)))
                                     .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
                                     .foregroundColor(Color.green)
                                     .rotationEffect(Angle(degrees: 270))
                                     .animation(.easeInOut(duration: 1.0))
                                FontIcon.text(.awesome5Solid(code: .hdd), fontsize: 14)
                                    .padding(.bottom, 15)
                                    .padding(.leading, 2)
                                Text("DISK")
                                    .font(.system(size: 10))
                                    .padding(.top, 20)
                                    .padding(.leading, 3)
                                
                                        

                            }
                            .frame(width: 55.0, height: 55.0)
                            .padding(0).onAppear(){
                                self.progressValue = (Float(my_BG_T.disk_usage) )/100*1.002
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        
                    }
                    .padding(EdgeInsets(top: -70, leading: 0, bottom: 10, trailing: 0))
            
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: 320,height: 1)
                .padding(.bottom, 10)
            
            HStack(spacing: 4.0) {
                VStack {
                    Text("CPU Usage: \(my_BG_T.cpu_usage)% \nCPU Temperature: \(my_BG_T.cpu_Temp_copy) °C\n\nMemory Usage: \(my_BG_T.memory_usage)%\n\nDisk Usage \(my_BG_T.disk_usage)%\n\(my_BG_T.network_info)")
                }
                .foregroundColor(Color.gray)
                .padding(.leading, -150)
            }
            .frame(width: 320)
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack {
                    Text("Quit")
                }
                .frame(width: 80, alignment: .center)
                
            }
            .padding(.top, 10)
            
        }
        .padding(.bottom, -80)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 320, height: 350)
    }
}


class CpuUpdateModel : ObservableObject {
    @Published var CpuPercent: Int = 5
    var CpuPercent_copy: Int = 0
    let observer = ActivityObserver()
    init() {
        observer.updatedStatisticsHandler = { observer in
            self.CpuPercent = Int(observer.cpuDescription)
            print("REAL CPU2 : "+String(self.CpuPercent))
        }
    }
    
    func setCpuPercent(percent: Int) {
        self.CpuPercent = percent
        print("REAL CPU: "+String(percent)+" CPU USAGE: "+String(Double(percent)/80))
    }
    
    func setCpuPercent2() {
        self.CpuPercent = self.CpuPercent_copy
        print("REAL CPU2 : "+String(CpuPercent))
    }
    
}


struct ProgressBar: View{
    @Binding var progress: Float
    var color: Color = Color.green
    
    
    var body: some View{
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
            Circle()
                 .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                 .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
                 .foregroundColor(color)
                 .rotationEffect(Angle(degrees: 270))
                 .animation(.easeInOut(duration: 1.0))
                 .environmentObject(CpuUpdateModel())

        }
    }
}
