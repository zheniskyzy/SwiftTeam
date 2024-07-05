//
//  Card.swift
//  SwiftTeam
//
//  Created by Benji Loya on 03.07.2024.
//


import SwiftUI

// Sample Card Model and Sample Data....
struct TaskCard: Identifiable, Hashable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var date: String = ""
    var title: String
}

