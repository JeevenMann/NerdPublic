//
//  Date Extension.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-05.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
extension Date {
    func todayDate() -> String {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        return dateFormatter.string(from: todayDate)
    }
}
