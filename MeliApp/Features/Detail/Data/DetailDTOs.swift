//
//  DetailDTOs.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

struct ItemDetailDTO: Decodable {
    let id: String
    let title: String
    let price: Double?
    let currencyId: String?
    let thumbnail: String?
    let condition: String?
    let soldQuantity: Int?
    let availableQuantity: Int?
    let permalink: String?

    enum CodingKeys: String, CodingKey {
        case id, title, price, thumbnail, condition, permalink
        case currencyId = "currency_id"
        case soldQuantity = "sold_quantity"
        case availableQuantity = "available_quantity"
    }

    func toDomain() -> ItemDetail {
        ItemDetail(
            id: id,
            title: title,
            price: price,
            currencyId: currencyId,
            thumbnailURL: thumbnail?.replacingOccurrences(of: "http://", with: "https://"),
            condition: condition,
            soldQuantity: soldQuantity,
            availableQuantity: availableQuantity,
            permalink: permalink,
            domainId: nil,
            status: nil,
            shortDescription: nil,
            attributes: [],
            dateCreated: nil,
            lastUpdated: nil,
            qualityType: nil,
            productStandard: nil,
            searchType: nil
        )
    }
}
