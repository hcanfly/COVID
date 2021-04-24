//
//  ContentView.swift
//  COVID
//
//  Created by Gary Hanson on 3/28/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.

//
//  https://corona.lmao.ninja/docs/                 // COVID API documentation
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var data = ViewModel()
//    @Environment(\.scenePhase) private var scenePhase

    init() {
        self.data.updateData()
    }
    
    var body : some View {
        VStack {
            if self.data.countries.count != 0 && self.data.data != nil {
                
                VStack {
                    
                    HStack(alignment: .top) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Updated: " + self.data.data.lastUpdated)
                                .fontWeight(.semibold)
                                .padding(.bottom, 10)

                            Text("COVID - 19")
                                .fontWeight(.semibold)
                                .font(.title)

                            Text("Total Cases: " + self.data.data.casesString)
                                .fontWeight(.semibold)
                                .font(.title)
                        }
                        .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            self.data.updateData()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 20)
                    .padding(.leading, 15)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.bottom, 30)
                    .background(Color.red)

                    HStack(spacing: 15) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Deaths")
                                .foregroundColor(Color.black.opacity(0.5))
                            
                            Text(self.data.data.deathsString)
                                .cellStyle()
                                .foregroundColor(.red)
                            
                        }.padding(.horizontal)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Recovered")
                                .foregroundColor(Color.black.opacity(0.5))
                            
                            Text(self.data.data.recoveredString)
                                .cellStyle()
                                .foregroundColor(.green)
                        }.padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            .cornerRadius(12)
                    }.offset(y: -65)
                        .padding(.bottom, -65)
                        .zIndex(25)
                    
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("Active Cases")
                            .foregroundColor(Color.black.opacity(0.5))
                        
                        Text(self.data.data.activesString)
                            .cellStyle()
                            .foregroundColor(.yellow)
                        
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(12)

                    // Country cell views
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(self.data.countries, id: \.self) { i in
                                cellView(details: i)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                .background(Color.gray)
            }
            else {
                GeometryReader { _ in
                    VStack {
                        Indicator()
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.data.updateData()
        }
        // this is not currently working. it used to work. will work again sometime.
//        .onChange(of: scenePhase) { phase in
//           if phase == .active {
//                self.data.updateData()
//            }
//        }
    }
}

extension Text {
    func cellStyle() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
    }
}

struct Indicator: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) ->  UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
