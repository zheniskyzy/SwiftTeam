//
//  Color.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI

extension Color {
    static var theme = ColorTheme()
}

struct ColorTheme {
    let primaryText = Color("PrimaryText")
    let viewBackground = Color("ViewBackground")
    
    let bgTabColor = Color("bgTabColor")
    let buttonsCreatePost = Color("buttonsCreatePost")
    let buttonsPostCard = Color("buttonsPostCard")
    let xmark = Color("xmark")
    
    let searchShadow = Color("searchShadow")
    
    //Task Card Colors
    let taskOrange = Color("taskOrange")
    let taskRed = Color("taskRed")
    let taskPurple = Color("taskPurple")
    let taskBlue = Color("taskBlue")
    let taskGreen = Color("taskGreen")
}
