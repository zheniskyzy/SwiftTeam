//
//  TripCard.swift
//  SwiftTeam
//
//  Created by Benji Loya on 03.07.2024.
//

import SwiftUI

struct CategoryCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

var categoryCards: [CategoryCard] = [
    .init(title: "New", subTitle: "IOS 18", image: "1"),
    .init(title: "Task", subTitle: "Knowledge Check", image: "2"),
    .init(title: "Chat", subTitle: "Connect with Peers", image: "3"),
    .init(title: "Job", subTitle: "Vacancies", image: "4")
]
