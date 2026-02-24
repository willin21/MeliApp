//
//  DetailModels.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

struct ItemDetail: Equatable {
    let id: String
    let title: String
    let price: Double?
    let currencyId: String?
    let thumbnailURL: String?
    let condition: String?
    let soldQuantity: Int?
    let availableQuantity: Int?
    let permalink: String?
    let domainId: String?
    let status: String?
    let shortDescription: String?
    let attributes: [ItemDetailAttribute]
    let dateCreated: String?
    let lastUpdated: String?
    let qualityType: String?
    let productStandard: Bool?
    let searchType: String?
}
