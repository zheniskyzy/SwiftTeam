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

var sampleTaskcards: [TaskCard] = [
    TaskCard(cardColor: Color.taskOrange, date: "Monday 8th November", title: "Neurobics for your \nmind."),
    TaskCard(cardColor: Color.taskRed, date: "Tuesday 9th November", title: "Brush up on hygine."),
    TaskCard(cardColor: Color.taskPurple, date: "Wednesday 10th November", title: "Don't skip breakfast."),
    TaskCard(cardColor: Color.taskBlue, date: "Thursday 11th November", title: "Brush up on hygine."),
    TaskCard(cardColor: Color.taskGreen, date: "Friday 12th November", title: "Neurobics for your \nmind."),
]
