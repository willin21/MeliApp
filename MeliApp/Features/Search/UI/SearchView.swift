//
//  Untitled.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    let di: AppDI
    
    @SceneStorage("search.query") private var persistedQuery: String = ""
    
    init(viewModel: SearchViewModel, di: AppDI) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.di = di
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            content
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Buscar productos")
        .searchable(
            text: $persistedQuery,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Ej. iPhone, silla, teclado"
        )
        .onAppear {
            if viewModel.query != persistedQuery {
                viewModel.onQueryChanged(persistedQuery)
            }
        }
        .onChange(of: persistedQuery) { _, newValue in
            viewModel.onQueryChanged(newValue)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                "Busca un producto",
                systemImage: "magnifyingglass",
                description: Text("Escribe en el buscador para ver resultados.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loading:
            VStack(spacing: 12) {
                ProgressView()
                Text("Buscando productos...")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty(let message):
            VStack(spacing: 12) {
                ContentUnavailableView(
                    "Sin resultados",
                    systemImage: "tray",
                    description: Text(message)
                )
                if !persistedQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button("Reintentar") { viewModel.retry() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let message):
            VStack(spacing: 12) {
                ContentUnavailableView(
                    "No se pudo cargar",
                    systemImage: "wifi.exclamationmark",
                    description: Text(message.userMessage)
                )
                Button("Reintentar") { viewModel.retry() }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let items):
            List(items) { item in
                NavigationLink {
                    DetailView(
                        viewModel: di.makeDetailViewModel(itemId: item.id),
                        itemTitleFallback: item.title
                    )
                } label: {
                    ItemRowView(item: item)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .scrollDismissesKeyboard(.immediately)
        case .unknownError(message: let message):
            VStack(spacing: 12) {
                ContentUnavailableView(
                    "No se pudo cargar",
                    systemImage: "wifi.exclamationmark",
                    description: Text(message)
                )
                Button("Reintentar") { viewModel.retry() }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
