//
//  CellView.swift
//  COVID
//
//  Created by Gary on 4/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct cellView : View {
    var details: Details
    @State private var show: Bool = false

    var body : some View {

        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(details.country)
                    .foregroundColor(.black)
                    .font(.title)
                // to avoid making a whole bunch of extra network calls to get the flags I downloaded
                // and saved them in the bundle. if you add more countries un-comment these lines to
                // easily get the link for the flag. then just download and add to Assets
//                Text(details.countryInfo.flag)
//                    .foregroundColor(.black)
                Image(details.countryInfo.iso2.lowercased())
                    .resizable()
                    .frame(width: 56)
                    // flags are 250 wide and vary in height this ratio is about average
                    .aspectRatio(1.65, contentMode: .fit)
                    .border(Color.black, width: 1)
                    .background(Color.gray)
                    .padding(.leading, 10)
                    .padding(.top, 24)

                Spacer()
                Button("History") {
                    self.show = true
                }
                .padding(10).border(show ? Color.red : Color.clear)
                .sheet(isPresented: $show,
                       onDismiss: { },
                       content: { HistoryView(countryCode: details.countryCode) })
            }
            .padding(.leading, 30)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {

                    HStack(spacing: 15) {

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Active Cases")
                                .foregroundColor(.black)
                                .font(.title2)

                            Text(self.details.casesString)
                                .foregroundColor(.yellow)
                                .font(.title2)

                            Spacer()

                            VStack(alignment: .leading, spacing: 2) {

                                Text("Cases Per Million")
                                    .foregroundColor(.black)

                                Text(self.details.casesPerMillionString)
                                    .foregroundColor(.black)

                                Text("Deaths Per Million")
                                    .foregroundColor(.black)

                                Text(self.details.deathsPerMillionString)
                                    .foregroundColor(.black)
                            }

                        }
                        .padding(.leading, 12)
                    }
                }
                .padding(.leading, 30)

                VStack(alignment: .leading, spacing: 12) {

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Today's Cases")
                            .foregroundColor(.black)

                        Text(self.details.todaysCasesString)
                            .foregroundColor(.black)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Today's Deaths")
                            .foregroundColor(.black)

                        Text(self.details.todayDeathsString)
                            .foregroundColor(.red)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Total Deaths")
                            .foregroundColor(.black)

                        Text(self.details.deathsString)
                            .foregroundColor(.red)
                    }
                }
                .padding(.leading, 40)
            }
       }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(20)
    }
}
