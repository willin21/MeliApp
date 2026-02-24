//
//  ProductsSearchDTOs.swift
//  MeliApp
//
//  Created by william niño on 22/02/26.
//

import Foundation

struct ProductsSearchResponseDTO: Decodable {
    let keywords: String?
    let paging: ProductsPagingDTO?
    let results: [ProductCatalogDTO]
    let queryType: String?

    enum CodingKeys: String, CodingKey {
        case keywords
        case paging
        case results
        case queryType = "query_type"
    }

    func toDomain(query: String) -> SearchPage {
        let items = results.map { $0.toSummary() }
        return SearchPage(query: query, items: items)
    }
}

struct ProductsPagingDTO: Decodable {
    let total: Int?
    let limit: Int?
    let offset: Int?
    let last: String?
}

struct ProductCatalogDTO: Decodable {
    let id: String
    let catalogProductId: String?
    let domainId: String?
    let name: String
    let status: String?
    let shortDescription: ProductShortDescriptionDTO?
    let pictures: [ProductPictureDTO]?
    let attributes: [ProductAttributeDTO]?
    let dateCreated: String?
    let lastUpdated: String?
    let qualityType: String?
    let productStandard: Bool?
    let searchType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catalogProductId = "catalog_product_id"
        case domainId = "domain_id"
        case name
        case status
        case shortDescription = "short_description"
        case pictures
        case attributes
        case dateCreated = "date_created"
        case lastUpdated = "last_updated"
        case qualityType = "quality_type"
        case productStandard = "product_standard"
        case searchType = "search_type"
    }

    func toSummary() -> ItemSummary {
        ItemSummary(
            id: id,
            title: name,
            thumbnailURL: pictures?.first?.url,
            price: nil,
            currencyId: nil,
            condition: nil,
            location: nil
        )
    }

    func toDetail() -> ItemDetail {
        ItemDetail(
            id: id,
            title: name,
            price: nil,
            currencyId: nil,
            thumbnailURL: pictures?.first?.url,
            condition: nil,
            soldQuantity: nil,
            availableQuantity: nil,
            permalink: nil,

            // NUEVOS CAMPOS
            domainId: domainId,
            status: status,
            shortDescription: shortDescription?.content,
            attributes: (attributes ?? []).compactMap { $0.toDomain() },
            dateCreated: dateCreated,
            lastUpdated: lastUpdated,
            qualityType: qualityType,
            productStandard: productStandard,
            searchType: searchType
        )
    }
}

struct ProductShortDescriptionDTO: Decodable {
    let type: String?
    let content: String?
}

struct ProductPictureDTO: Decodable {
    let id: String?
    let url: String?
    let maxWidth: String?
    let maxHeight: String?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case maxWidth = "max_width"
        case maxHeight = "max_height"
    }
}

struct ProductAttributeDTO: Decodable {
    let id: String?
    let name: String?
    let valueId: String?
    let valueName: String?
    let values: [ProductAttributeValueDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case valueId = "value_id"
        case valueName = "value_name"
        case values
    }

    func toDomain() -> ItemDetailAttribute? {
        guard let name, !name.isEmpty else { return nil }

        let value = valueName
            ?? values?.compactMap(\.name).first
            ?? "N/A"

        return ItemDetailAttribute(
            id: id ?? UUID().uuidString,
            name: name,
            value: value
        )
    }
}

struct ProductAttributeValueDTO: Decodable {
    let id: String?
    let name: String?
}
