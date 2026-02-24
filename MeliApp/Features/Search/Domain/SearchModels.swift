//
//  SearchModels.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

struct ItemSummary: Identifiable, Hashable {
    let id: String
    let title: String
    let thumbnailURL: String?
    let price: Double?
    let currencyId: String?
    let condition: String?
    let location: String?
}

struct SearchPage {
    let query: String
    let items: [ItemSummary]
}
