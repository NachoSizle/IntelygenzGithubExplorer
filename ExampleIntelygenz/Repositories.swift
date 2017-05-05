//
//  Repositories.swift
//  Example2
//
//  Created by Nacho Martinez on 4/5/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import Foundation
import UIKit

class Repositories: NSObject {
    
    var nameRepo: String!
    var createdAt: String!
    var nameAuthor: String!
    var repoUrl: String!
    var watchers: String!
    var forks: String!
    var stars: String!
    var descRepo: String!
    var updateDate: Date!
    
    init(nameRepo: String, nameAuthor: String, createdAt: String, repoUrl: String, watchers: String, forks: String, stars: String, description: String, updateDate: Date) {
        self.nameRepo = nameRepo
        self.nameAuthor = nameAuthor
        self.createdAt = createdAt
        self.repoUrl = repoUrl
        self.watchers = watchers
        self.forks = forks
        self.stars = stars
        self.descRepo = description
        self.updateDate = updateDate
    }
}
