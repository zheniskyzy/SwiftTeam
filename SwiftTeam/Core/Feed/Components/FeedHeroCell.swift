//
//  FeedHeroCell.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SwiftfulUI

struct FeedHeroCell: View {
    
    var imageName: String = Constants.randomImage
    var isNetflixFilm: Bool = true
    var title: String = "Player"
    var categories: [String] = ["Task", "Resume", "IOS"]
    var onBackgroundPressed: (() -> Void)? = nil
    var onPlayPressed: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ImageLoaderView(urlString: imageName)
            
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    if isNetflixFilm {
                        HStack(spacing: 8) {
                            Text("S")
                                .foregroundStyle(.red)
                                .font(.largeTitle)
                                .fontWeight(.black)
                            
                            Text("SWIFT")
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .kerning(3)
                                .shadow(color: .black, radius: 1)
                            
                        }
                    }
                    Text(title)
                        .font(.system(size: 50, weight: .medium, design: .serif))
                }
                
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .font(.callout)
                        
                        if category != categories.last {
                            Circle()
                                .frame(width: 4, height: 4)
                        }
                    }
                }
                
                HStack(spacing: 16) {
                    HStack {
                         Image(systemName: "play.fill")
                        Text("Go")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(.gray)
                    .cornerRadius(4)
                    .asButton(.press) {
                        onPlayPressed?()
                    }
                }
                .font(.callout)
                .fontWeight(.medium)
            }
            .padding(24)
            .background(
                LinearGradient(
                    colors: [
                        .black.opacity(0),
                        .black.opacity(0.4),
                        .black.opacity(0.4),
                        .black.opacity(0.4)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .foregroundStyle(.white)
        .cornerRadius(10)
        .aspectRatio(0.8, contentMode: .fit)
        .asButton(.press) {
            onBackgroundPressed?()
        }
    }
}

#Preview {
    FeedHeroCell()
        .padding(40)
}
