//
//  DetailViewModel.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//
import Foundation
internal import Combine
internal import os

@MainActor
final class DetailViewModel: ObservableObject {
    @Published var state: ViewState<DetailPresentationModel> = .idle

    private let itemId: String
    private let fetchItemDetailUseCase: FetchItemDetailUseCase

    init(itemId: String, fetchItemDetailUseCase: FetchItemDetailUseCase) {
        self.itemId = itemId
        self.fetchItemDetailUseCase = fetchItemDetailUseCase
    }

    func loadIfNeeded() async {
        if case .loaded = state { return }
        await load()
    }

    func load() async {
        state = .loading
        do {
            let detail = try await fetchItemDetailUseCase.execute(itemId: itemId)
            let presentation = mapToPresentation(detail)
            state = .loaded(presentation)
        } catch let error as AppError {
            AppLogger.ui.error("Detail error: \(error.localizedDescription)")
            state = .error(error)
        } catch {
            AppLogger.ui.error("Detail unknown error: \(error.localizedDescription)")
            state = .unknownError(message: AppError.unknown.userMessage)
        }
    }

    private func mapToPresentation(_ detail: ItemDetail) -> DetailPresentationModel {
        let hasPrice = detail.price != nil

        let primaryRows: [DetailInfoRow] = buildRows([
            ("id", "ID", detail.id),
            ("condition", "Condición", localizedCondition(detail.condition)),
            ("available", "Disponibles", detail.availableQuantity.map(String.init)),
            ("sold", "Vendidos", detail.soldQuantity.map(String.init))
        ])

        let technicalRows: [DetailInfoRow] = buildRows([
            ("status", "Estado", normalized(detail.status)),
            ("domain", "Dominio", detail.domainId),
            ("quality", "Calidad", normalized(detail.qualityType)),
            ("searchType", "Tipo de búsqueda", normalized(detail.searchType)),
            ("standard", "Producto estándar", detail.productStandard.map { $0 ? "Sí" : "No" }),
            ("created", "Creado", formatISODate(detail.dateCreated)),
            ("updated", "Actualizado", formatISODate(detail.lastUpdated))
        ])

        let trimmedDescription = detail.shortDescription?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let permalinkURL = detail.permalink.flatMap(URL.init(string:))

        return DetailPresentationModel(
            id: detail.id,
            title: detail.title,
            imageURL: detail.thumbnailURL,
            priceText: hasPrice ? PriceFormatter.cop(detail.price) : "Precio no disponible",
            hasPrice: hasPrice,
            descriptionText: (trimmedDescription?.isEmpty == false) ? trimmedDescription : nil,
            attributes: detail.attributes,
            primaryRows: primaryRows,
            technicalRows: technicalRows,
            permalinkURL: permalinkURL
        )
    }

    private func buildRows(_ rows: [(id: String, label: String, value: String?)]) -> [DetailInfoRow] {
        rows.compactMap { row in
            guard let value = row.value?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty else {
                return nil
            }

            return DetailInfoRow(id: row.id, label: row.label, value: value)
        }
    }

    private func localizedCondition(_ condition: String?) -> String? {
        guard let condition else { return nil }

        switch condition.lowercased() {
        case "new": return "Nuevo"
        case "used": return "Usado"
        default: return normalized(condition)
        }
    }

    private func normalized(_ value: String?) -> String? {
        guard let value, !value.isEmpty else { return nil }

        return value
            .replacingOccurrences(of: "_", with: " ")
            .lowercased()
            .capitalized
    }

    private func formatISODate(_ value: String?) -> String? {
        guard let value, !value.isEmpty else { return nil }

        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: value) else { return value }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CO")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
