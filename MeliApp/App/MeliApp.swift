//
//  MeliApp.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import SwiftUI

@main
struct MeliApp: App {
    private let di = AppDI()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SearchView(
                    viewModel: di.makeSearchViewModel(),
                    di: di
                )
            }
        }
    }
}
