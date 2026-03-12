//
//  ItemRowView.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import SwiftUI

struct ItemRowView: View {
    let item: ItemSummary
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.thumbnailURL ?? "")) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.15)
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)

                Text(PriceFormatter.cop(item.price))
                    .font(.headline)

                if let location = item.location, !location.isEmpty {
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .imageScale(.medium)
                    .foregroundStyle(isFavorite ? Color.red : Color.secondary)
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(isFavorite ? "Quitar de favoritos" : "Agregar a favoritos")
        }
        .padding(.vertical, 4)
    }
}
