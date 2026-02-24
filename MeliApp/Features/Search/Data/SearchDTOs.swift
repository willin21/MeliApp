//
//  SearchDTOs.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let query: String?
    let results: [SearchItemDTO]?
}

struct SearchItemDTO: Decodable {
    let id: String?
    let title: String?
    let thumbnail: String?
    let price: Double?
    let currencyId: String?
    let condition: String?
    let address: SearchAddressDTO?

    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, price, condition, address
        case currencyId = "currency_id"
    }
}

struct SearchAddressDTO: Decodable {
    let stateName: String?
    let cityName: String?

    enum CodingKeys: String, CodingKey {
        case stateName = "state_name"
        case cityName = "city_name"
    }
}

extension SearchResponseDTO {
    func toDomain() -> SearchPage {
        let mapped = (results ?? []).compactMap { dto -> ItemSummary? in
            guard let id = dto.id, let title = dto.title else { return nil }

            let location = [dto.address?.cityName, dto.address?.stateName]
                .compactMap { $0 }
                .joined(separator: ", ")

            return ItemSummary(
                id: id,
                title: title,
                thumbnailURL: dto.thumbnail?.asSecureURL(),
                price: dto.price,
                currencyId: dto.currencyId,
                condition: dto.condition,
                location: location.isEmpty ? nil : location
            )
        }

        return SearchPage(query: query ?? "", items: mapped)
    }
}
