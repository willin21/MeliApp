//
//  PriceFormatter.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

enum PriceFormatter {
    static func cop(_ value: Double?) -> String {
        guard let value else { return "Sin precio" }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        formatter.currencyCode = "COP"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(Int(value))"
    }
}
