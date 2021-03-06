//
//  Model.swift
//  COVID
//
//  Created by Gary on 4/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation
import os.log


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

struct CountryInfo : Decodable, Hashable {
    var iso2: String
    var iso3: String
    var flag: String
}

struct Details : Decodable, Hashable {
    var country: String
    var countryInfo: CountryInfo
    var cases: Int?
    var todayCases: Int?
    var deaths: Int?
    var todayDeaths: Int?
    var recovered: Int?
    var critical: Int?
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


class ViewModel : ObservableObject {
    @Published var data: Case!
    @Published var countries = [Details]()


    func updateData() {

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let sessionTotals = URLSession(configuration: config)
        let sessionCountries = URLSession(configuration: config)

        // TODO: these two network calls really should be zipped so that
        // UI is only updated once. but this works fine so putting it off due to laziness
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
    guard let dateTime = time else {
        return ""
    }

    let date = Double(dateTime / 1000)
    let formatter = DateFormatter()

    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    let timeUTC = Date(timeIntervalSince1970: TimeInterval(exactly: date)!)
    formatter.timeZone = TimeZone.current
    let dateString = formatter.string(from: timeUTC)

    return dateString
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

// these are iso2 country codes. https://www.nationsonline.org/oneworld/country_code_list.htm
fileprivate let countryCodes = [ "us", "kr", "sg", "tw", "cn", "br", "in", "mx"]
fileprivate let countryCodeList = countryCodes.joined(separator: ",")

extension URL {
    fileprivate static var summaryData: URL {
        URL(string: "https://disease.sh/v2/all")!
    }

    fileprivate static var countriesDetail: URL {
        URL(string: "https://corona.lmao.ninja/v2/countries/\(countryCodeList)")!
    }

    fileprivate static func detail(for country: String) -> URL {
        URL(string: "https://corona.lmao.ninja/countries/\(country)")!
    }

    static func history(for country: String, daysBack: Int) -> URL {
        URL(string: "https://disease.sh/v3/covid-19/historical/\(country)?lastdays=\(daysBack)")!
    }
}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let networkLogger = OSLog(subsystem: subsystem, category: "log_networkcall")
}

