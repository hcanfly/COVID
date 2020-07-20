//
//  HistoryViewModel.swift
//  COVID
//
//  Created by Gary on 7/20/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation


struct Timeline: Decodable {
    var cases: [String: Int]?
    var deaths: [String: Int]?
}

struct History : Decodable {
    var country: String?
    var timeline: Timeline?
}

class HistoryViewModel : ObservableObject {
    @Published var data = History()
    var caseTotals = [0, 1]
    var deathTotals = [0, 1]

    func updateData(for country: String, daysBack: Int) {

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let sessionTotals = URLSession(configuration: config)

        sessionTotals.dataTask(with: .history(for: country, daysBack: daysBack)) { (data, _, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            let json = try! JSONDecoder().decode(History.self, from: data!)
            DispatchQueue.main.async {
                self.data = json
                self.caseTotals = self.cases()
                self.deathTotals = self.deaths()
            }
        }.resume()
    }

    // cases and deaths come as dictionaries [dateString: count]. They are in date order in the json,
    // but dictionaries are not ordered, so the order becomes random. Not what we need.
    // these functions create date-ordered arrays of the counts because the charts just plot the count and don't need the dates

    private func cases() -> [Int] {
        guard let dataCases = self.data.timeline?.cases else {
            return [1]
        }

        var a = [(Date, Int)]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        for (k,v) in dataCases {
            a.append((dateFormatter.date(from: k)!, v))
        }
        a.sort {
            $0.0 < $1.0
        }

        var b = [Int]()
        for (_,c) in a {
            b.append(c)
        }
        return b
    }

    private func deaths() -> [Int] {
        guard let dataDeaths = self.data.timeline?.deaths else {
            return [1]
        }
        var a = [(Date, Int)]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        for (k,v) in dataDeaths {
            a.append((dateFormatter.date(from: k)!, v))
        }
        a.sort {
            $0.0 < $1.0
        }

        var b = [Int]()
        for (_,c) in a {
            b.append(c)
        }

        return b
    }

}
