//
//  User.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
}

struct Address: Equatable, Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo?
}

struct Geo: Equatable, Codable {
    let lat: String
    let lng: String
}

struct Company: Equatable, Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
