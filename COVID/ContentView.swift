//
//  ContentView.swift
//  COVID
//
//  Created by Gary Hanson on 3/28/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.

//  https://www.youtube.com/watch?v=UEjiDemnkoI     // Kavsoft video
//
//  https://corona.lmao.ninja/docs/                 // API documentation
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @ObservedObject var data = Model()
    
    var body : some View {
        VStack {
            if self.data.countries.count != 0 && self.data.data != nil {
                
                VStack {
                    
                    HStack(alignment: .top) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Updated: " + self.data.data.lastUpdated)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("COVID - 19")
                                .fontWeight(.semibold)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text("Total Cases: " + self.data.data.casesString)
                                .fontWeight(.semibold)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.data.updateData()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 90)
                    .padding()
                    .padding(.bottom, 50)
                    .background(Color.red)
                    
                    HStack(spacing: 15) {
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Deaths")
                                .foregroundColor(Color.black.opacity(0.5))
                            
                            Text(self.data.data.deathsString)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                        }.padding(.horizontal)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Recovered")
                                .foregroundColor(Color.black.opacity(0.5))
                            
                            Text(self.data.data.recoveredString)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            
                        }.padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            .cornerRadius(12)
                    }.offset(y: -60)
                        .padding(.bottom, -60)
                        .zIndex(25)
                    
                    
                    VStack(alignment: .center, spacing: 15) {
                        Text("Active Cases")
                            .foregroundColor(Color.black.opacity(0.5))
                        
                        Text(self.data.data.activesString)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        
                    }.padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.top, 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 15) {
                            
                            ForEach(self.data.countries, id: \.self) { i in
                                cellView(details: i)
                            }
                        }
                    }
                    .padding(.bottom, 100)
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
        }.edgesIgnoringSafeArea(.top)
            .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
            .onAppear {
                self.data.updateData()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.data.updateData()
        }
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
