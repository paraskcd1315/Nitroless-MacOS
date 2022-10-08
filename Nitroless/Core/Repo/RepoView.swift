//
//  RepoView.swift
//  Nitroless
//
//  Created by Paras KCD on 2022-10-08.
//

import SwiftUI
import Kingfisher

struct RepoView: View {
    @StateObject var viewModel: ContentViewModel
    @State private var hovered = Hovered(image: "", hover: false)
    
    var body: some View {
        List {
            Image("Icon")
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: (viewModel.isHomeActive == true) || (self.hovered.image == "Icon" && self.hovered.hover == true) ? 8 : 99, style: .continuous))
                .animation(.spring(), value: self.hovered.hover && !viewModel.isHomeActive)
                .onHover { isHovered in
                    self.hovered = Hovered(image: "Icon", hover: isHovered)
                    DispatchQueue.main.async { //<-- Here
                        if (self.hovered.hover) {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                }
                .onTapGesture {
                    viewModel.makeAllReposInactive()
                }
            
            VStack {
                ForEach(viewModel.repos, id: \.url) {
                    repo in
                    KFImage(URL(string: "\(repo.url)/\(repo.emote.icon)"))
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: (self.hovered.image == "\(repo.url)/\(repo.emote.icon)" && self.hovered.hover == true) || (repo.active == true) ? 8 : 99, style: .continuous))
                        .animation(.spring(), value: self.hovered.hover && !repo.active)
                        .onHover { isHovered in
                            self.hovered = Hovered(image: "\(repo.url)/\(repo.emote.icon)", hover: isHovered)
                            DispatchQueue.main.async { //<-- Here
                                if (self.hovered.hover) {
                                    NSCursor.pointingHand.push()
                                } else {
                                    NSCursor.pop()
                                }
                            }
                        }
                        .onTapGesture {
                            viewModel.makeRepoActive(url: repo.url)
                        }
                }
            }
        }
        .removeBackground()
        .frame(width: 72)
    }
}
