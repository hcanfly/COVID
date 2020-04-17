//
//  Model.swift
//  COVID
//
//  Created by Gary on 4/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation


struct Case : Decodable {
    var cases: Int?
    var deaths: Int?
    var updated: Double?
    var recovered: Int?
    var active: Int?

    var lastUpdated: String {
        getDateString(time: updated)
    }

    var casesString: String {
        getIntString(data: cases)
    }

    var deathsString: String {
        getIntString(data: deaths)
    }

    var recoveredString: String {
        getIntString(data: recovered)
    }

    var activesString: String {
        getIntString(data: active)
    }
}

struct Details : Decodable, Hashable {
    var country: String
    var cases: Int?
    var todayCases: Int
    var deaths: Int
    var todayDeaths: Int
    var recovered: Int
    var critical: Int
    var casesPerOneMillion: Double
    var deathsPerOneMillion: Double

    var todaysCasesString: String {
        getIntString(data: todayCases)
    }

    var casesString: String {
        getIntString(data: cases)
    }

    var deathsString: String {
        getIntString(data: deaths)
    }

    var todayDeathsString: String {
        getIntString(data: todayDeaths)
    }

    var recoveredString: String {
        getIntString(data: recovered)
    }

    var casesPerMillionString: String {
        getDoubleString(data: casesPerOneMillion)
    }

    var deathsPerMillionString: String {
        getDoubleString(data: deathsPerOneMillion)
    }

}


class Model : ObservableObject {
    @Published var data: Case!
    @Published var countries = [Details]()

    init() {
        updateData()
    }

    func updateData() {

        let sessionTotals = URLSession(configuration: .default)
        let sessionCountries = URLSession(configuration: .default)

        sessionTotals.dataTask(with: .summaryData) { (data, _, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            let json = try! JSONDecoder().decode(Case.self, from: data!)
            DispatchQueue.main.async {
                self.data = json
            }
        }.resume()

        sessionCountries.dataTask(with: .countriesDetail) { (data, _, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            let json = try! JSONDecoder().decode([Details].self, from: data!)
            DispatchQueue.main.async {
                self.countries = json
            }
        }.resume()
    }
}


fileprivate func getDateString(time: Double?) -> String {
    guard let time = time else {
        return ""
    }

    let date = Double(time / 1000)
    let format = DateFormatter()

    format.dateStyle = .medium
    format.timeStyle = .medium

    return format.string(from: Date(timeIntervalSince1970: TimeInterval(exactly: date)!))
}

fileprivate func getDoubleString(data: Double) -> String {

    let format = NumberFormatter()
    format.numberStyle = .decimal

    return format.string(for: data)!
}

fileprivate func getIntString(data: Int?) -> String {

    guard let data = data else {
        return "0"
    }

    let format = NumberFormatter()
    format.numberStyle = .decimal

    return format.string(for: data)!
}


extension URL {
    fileprivate static var summaryData: URL {
        URL(string: "https://corona.lmao.ninja/v2/all")!
    }

    fileprivate static var countriesDetail: URL {
        URL(string: "https://corona.lmao.ninja/v2/countries/usa,singapore,taiwan,korea,china,italy,spain,sweden")!
    }

    fileprivate static func detail(for country: String) -> URL {
        URL(string: "https://corona.lmao.ninja/countries/\(country)")!
    }
}
