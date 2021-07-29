//
//  String Extension.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-05-01.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation

extension String {
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
