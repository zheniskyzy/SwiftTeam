//
//  CircularProfileImageView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SDWebImageSwiftUI

enum ProfileImageSize {
    case xxxLSmall
    case xxxSmall
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxxLSmall: return 14
        case .xxxSmall: return 22
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 48
        case .large: return 64
        case .xLarge: return 80
        }
    }
    
    var fontSize: CGFloat {
          switch self {
          case .xxxLSmall: return 8
          case .xxxSmall: return 12
          case .xxSmall: return 14
          case .xSmall: return 16
          case .small: return 18
          case .medium: return 20
          case .large: return 24
          case .xLarge: return 28
          }
      }
    
}

struct UserInitialsView: View {
    let fullname: String
    let fontSize: CGFloat
    
    private var initials: String {
        let names = fullname.split(separator: " ")
        let firstInitial = names.first?.first?.uppercased() ?? ""
        let lastInitial = names.count > 1 ? names.last?.first?.uppercased() ?? "" : ""
        return "\(firstInitial)\(lastInitial)"
    }
    
    var body: some View {
        Text(initials)
            .font(.system(size: fontSize, weight: .semibold))
            .frame(width: fontSize * 2, height: fontSize * 2)
            .background(Color.gray.opacity(0.33))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

/*
struct CircularProfileImageView: View {
    var user: User?
    let size: ProfileImageSize
    
    var body: some View {
        if let imageUrl = user?.profileImageUrl {
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            UserInitialsView(fullname: user?.fullname ?? "User", fontSize: size.fontSize)
                .frame(width: size.dimension, height: size.dimension)
        }
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(user: User(fullname: "John Doe", email: "john.doe@example.com", username: "johndoe", id: "123"), size: .small)
    }
}
*/
