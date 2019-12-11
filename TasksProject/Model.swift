//
//  Model.swift
//  TasksProject
//
//  Created by Veera Diande on 11/12/19.
//  Copyright © 2019 Brandenburg. All rights reserved.
//

import Foundation
struct FactsData: Codable {
    let title: String
    let rows: [Row]
    
    init(title: String, rows: [Row]) {
        self.title = title
        self.rows = rows
    }
}

// MARK: - Row
struct Row: Codable {
    let title, rowDescription: String?
    let imageHref: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case rowDescription = "description"
        case imageHref
    }
    
    init(title: String?, rowDescription: String?, imageHref: String?) {
        self.title = title
        self.rowDescription = rowDescription
        self.imageHref = imageHref
    }
}

