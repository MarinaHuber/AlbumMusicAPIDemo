//
//  DateFormatter.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 17/12/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Foundation
// not needed????
extension DateFormatter {
    static var objectDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
