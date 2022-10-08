//
//  Emote.swift
//  Nitroless
//
//  Created by Paras KCD on 2022-10-08.
//

import Foundation

struct Emote: Codable {
    let name, icon, path: String
    let emotes: [EmoteElement]
}

struct EmoteElement: Codable {
    let name: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case gif = "gif"
    case png = "png"
    case jpg = "jpg"
}
