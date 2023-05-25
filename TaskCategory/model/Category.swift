//
//  Category.swift
//  TaskCategory
//
//  Created by Bekhruz Hakmirzaev on 25/05/23.
//

import Foundation

struct Category: Codable {
    var id: Int?
    var parentId: Int?
    var childs: [Category]?
}

