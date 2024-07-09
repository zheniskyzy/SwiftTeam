//
//  Card.swift
//  SwiftTeam
//
//  Created by Benji Loya on 03.07.2024.
//


import SwiftUI

// Sample Card Model and Sample Data....
struct TaskLevel: Identifiable, Hashable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var title: String
    var subtitle: String
}

var sampleTaskLevels: [TaskLevel] = [
    TaskLevel(cardColor: Color.taskGreen, title: "Beginner", subtitle: "Easy 10 tasks"),
    TaskLevel(cardColor: Color.taskBlue, title: "Intermediate", subtitle: "Middle 10 tasks"),
    TaskLevel(cardColor: Color.taskRed, title: "Advanced", subtitle: "Hard 10 task"),
]
