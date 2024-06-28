//
//  Post.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI

struct Post: Identifiable, Codable, Hashable {
    
 //   @DocumentID private var threadId: String?
    let id: UUID // временно
    let ownerUid: String
    let caption: String?
  //  let timestamp: Timestamp
    var mediaFiles: [MediaFile]?
    var likes: Int
    var replyCount: Int
    var user: User?
    var didLike: Bool? = false
    
//    var id: String {
//        return threadId ?? UUID().uuidString
//    }
}

struct MediaFile: Codable, Hashable {
    let url: String
    let type: MediaType
    
    enum MediaType: String, Codable, Hashable {
        case image
        case video
    }
}
