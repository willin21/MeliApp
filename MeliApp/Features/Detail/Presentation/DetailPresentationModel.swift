//
//  DetailPresentationModel.swift
//  MeliApp
//
//  Created by william niño on 22/02/26.
//

import Foundation

struct DetailPresentationModel: Equatable {
    let id: String
    let title: String
    let imageURL: String?
    let priceText: String
    let hasPrice: Bool
    let descriptionText: String?
    let attributes: [ItemDetailAttribute]
    let primaryRows: [DetailInfoRow]
    let technicalRows: [DetailInfoRow]
    let permalinkURL: URL?
}

struct DetailInfoRow: Identifiable, Equatable {
    let id: String
    let label: String
    let value: String
}
