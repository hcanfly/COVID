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

    var body : some View {

        VStack(alignment: .leading, spacing: 15) {

            Text(details.country)
                .foregroundColor(.black)
                .font(.title)

            HStack(spacing: 15) {

                VStack(alignment: .leading, spacing: 12) {

                    Text("Active Cases")
                        .foregroundColor(.black)
                        .font(.title)

                    Text(self.details.casesString)
                        .foregroundColor(.yellow)
                        .font(.title)

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

                        Text("Recovered")
                        .foregroundColor(.black)

                        Text(self.details.recoveredString)
                            .foregroundColor(.green)
                    }

                }
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(20)
    }
}
