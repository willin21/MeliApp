//
//  DetailView.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import SwiftUI

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    let itemTitleFallback: String

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            contentView
        }
        .navigationTitle(itemTitleFallback)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle, .loading:
            VStack(spacing: 12) {
                ProgressView()
                Text("Cargando detalle...")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            VStack(spacing: 16) {
                statusPlaceholder(
                    icon: "exclamationmark.triangle",
                    title: "No se pudo cargar el detalle",
                    message: message.userMessage
                )

                Button("Reintentar") {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty(let message):
            statusPlaceholder(
                icon: "tray",
                title: "Sin información",
                message: message
            )
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let item):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection(item)

                    if let description = item.descriptionText, !description.isEmpty {
                        infoCard(title: "Descripción") {
                            Text(description)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }

                    if !item.attributes.isEmpty {
                        infoCard(title: "Características") {
                            VStack(spacing: 10) {
                                ForEach(Array(item.attributes.enumerated()), id: \.element.id) { index, attribute in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text(attribute.name)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 130, alignment: .leading)

                                        Text(attribute.value)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .font(.subheadline)

                                    if index < item.attributes.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }

                    if !item.primaryRows.isEmpty {
                        infoCard(title: "Resumen") {
                            rowsSection(item.primaryRows)
                        }
                    }

                    if !item.technicalRows.isEmpty {
                        infoCard(title: "Información técnica") {
                            rowsSection(item.technicalRows)
                        }
                    }

                    if let url = item.permalinkURL {
                        Link(destination: url) {
                            Label("Ver en Mercado Libre", systemImage: "link")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.clear)
        case .unknownError(message: let message):
            VStack(spacing: 16) {
                statusPlaceholder(
                    icon: "exclamationmark.triangle",
                    title: "No se pudo cargar el detalle",
                    message: message
                )
                
                Button("Reintentar") {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder
    private func statusPlaceholder(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36, weight: .regular))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 320)
    }

    @ViewBuilder
    private func headerSection(_ item: DetailPresentationModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: item.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()

                case .failure(_):
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.15))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                        )

                case .empty:
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.15))
                        .overlay(ProgressView())

                @unknown default:
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.15))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(item.title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(item.priceText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(item.hasPrice ? Color.primary : Color.secondary)
        }
    }

    @ViewBuilder
    private func rowsSection(_ rows: [DetailInfoRow]) -> some View {
        VStack(spacing: 10) {
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                HStack(alignment: .top, spacing: 12) {
                    Text(row.label)
                        .foregroundStyle(.secondary)
                        .frame(width: 130, alignment: .leading)

                    Text(row.value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.subheadline)

                if index < rows.count - 1 {
                    Divider()
                }
            }
        }
    }

    @ViewBuilder
    private func infoCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content()
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
