//
//  String+SecureURL.swift
//  MeliApp
//
//  Created by william niño on 21/02/26.
//

import Foundation

extension String {
    func asSecureURL() -> String {
        replacingOccurrences(of: "http://", with: "https://")
    }
}
