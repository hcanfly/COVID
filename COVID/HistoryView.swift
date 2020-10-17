//
//  HistoryView.swift
//  COVID
//
//  Created by Gary on 7/19/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    let countryCode: String
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var data = HistoryViewModel()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Text("Total Cases").font(.headline)
                VStack {
                    HStack {
                        VStack {
                            Text(String(formattedCountString(from: data.caseTotals.max()!)))
                                .font(.footnote)
                            Spacer()
                            Text(String(formattedCountString(from: data.caseTotals.min()!)))
                                .font(.footnote)
                       }
                        ChartView(data: data.caseTotals, lineColor: .yellow)
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .border(Color.blue, width: 2)
                    }
                }
                .frame(width: 320, height: 120.0)
                .padding(.bottom, 40)
               Text("Total Deaths").font(.headline)
                VStack {
                    HStack {
                        VStack {
                            Text(String(formattedCountString(from: data.deathTotals.max()!)))
                                .font(.footnote)
                            Spacer()
                            Text(String(formattedCountString(from: data.deathTotals.min()!)))
                                .font(.footnote)
                       }
                        ChartView(data: data.deathTotals, lineColor: .red)
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .border(Color.blue, width: 2)
                    }
                }
                .frame(width: 320, height: 120.0)
                .padding(.bottom, 30)
                Text("Since " + startDateString())
    //            Spacer()
    //            VStack(spacing: 20) {
    //                Text("Close")
    //                    .onTapGesture {
    //                        // Dismissing programmatically, instead of using the gesture,
    //                        // will not trigger the onDismiss callback
    //                        // If you need to perform a task on dismissal, do it here.
    //                        self.presentationMode.wrappedValue.dismiss()
    //                }
    //                .padding(.bottom, 10)
    //            }
            }
            .frame(width: 380)
            .foregroundColor(.white)
        }
        .onAppear {
            self.data.updateData(for: self.countryCode, daysBack: daysToChart())
        }
    }
}


// Picking March 1, 2020 as the start date because that is when cases and deaths started climbing in the US. Pick your own starting date.
fileprivate let startDate = "2020-03-01"


fileprivate func startDateString() -> String {
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy-MM-dd"
    let start = dateFormatter.date(from: startDate)!

    let formatter = DateFormatter()
    formatter.dateStyle = .long

    return formatter.string(from: start)
}

fileprivate func daysToChart() -> Int {
    let previousDate = startDate
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let previousDateFormated: Date? = dateFormatter.date(from: previousDate)
    let difference = currentDate.timeIntervalSince(previousDateFormated!)
    let differenceInDays = Int(difference/(60 * 60 * 24 ))

    return differenceInDays
}

fileprivate func formattedCountString(from count: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal

    return numberFormatter.string(from: NSNumber(value:count))!
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(countryCode: "usa")
    }
}

