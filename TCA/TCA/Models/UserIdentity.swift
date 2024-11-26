//
//  UserIdentity.swift
//  TCA
//
//  Created by Nataliya Lazouskaya on 26/11/2024.
//

import Foundation

struct UserIdentity: Codable {
    var token: String?

    init(token: String?) {
        self.token = token
    }
}
