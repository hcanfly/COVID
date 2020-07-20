//
//  ChartView.swift
//  COVID
//
//  Created by Gary on 7/20/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct ChartView: View {
    let data: [Int]
    let lineColor: Color

    var body: some View {
        GraphView(data: data)
            .stroke(lineColor, lineWidth: 1)

    }
}

struct GraphView: Shape {
    let data: [Int]

    func path(in bounds: CGRect) -> Path {
        let dataValues = data
        let dataMax = dataValues.max()!
        let dataMin = dataValues.min()!
        let dataRange = CGFloat(dataMax - dataMin)
        var xPos: CGFloat = 10
        let increment: CGFloat = (bounds.width - 20) / (CGFloat(data.count) - 1)
        let yRange = bounds.height - 14

        var path = Path()

        for index in (0..<dataValues.count) {
            let v = CGFloat(dataValues[index] - dataMin)
            let yPos = CGFloat(v / dataRange) * yRange + 8
            if index == 0 {
                path.move(to: CGPoint(x: xPos, y: bounds.height - yPos))
            } else {
                path.addLine(to: CGPoint(x: xPos, y: bounds.height - yPos))
            }
            xPos += increment
        }

        return path
    }
}
