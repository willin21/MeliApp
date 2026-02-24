//
//  ViewState.swift
//  MeliApp
//
//  Created by william niño on 18/02/26.
//

import Foundation

enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case empty(message: String)
    case error(AppError)
    case unknownError(message: String)
}
