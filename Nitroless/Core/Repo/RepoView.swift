//
//  RepoView.swift
//  Nitroless
//
//  Created by Paras KCD on 2022-10-08.
//

import SwiftUI

struct RepoView: View {
    var body: some View {
        List {
            Image("Icon")
                .resizable()
                .frame(width: 48, height: 48)
        }
        .removeBackground()
        .frame(width: 72)
    }
}

struct RepoView_Previews: PreviewProvider {
    static var previews: some View {
        RepoView()
    }
}
