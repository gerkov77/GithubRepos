//
//  RepoListRow.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 22..
//

import SwiftUI

struct RepoListRow {
    let repoName: String
    let userName: String
    var imageUrl: String
}

extension RepoListRow: View {

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl), scale: 1) { image in
                image.resizable()
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
            } placeholder: {
                Image("github-32")
                    .resizable()
                    .frame(width: 44, height: 44)
            }

            VStack(alignment: .leading) {
                Text(repoName)
                    .font(Appfonts.regular(size: 13).font)
                .padding(.horizontal)
                .padding(.bottom, -1)
                Text(userName)
                    .font(Appfonts.medium(size: 10).font)
                .padding(.horizontal)
            }
            Spacer()
        }
        .padding(8)
//        .background(Color.orange)
    }
}

struct RepoListRow_Previews: PreviewProvider {
    static var previews: some View {
        RepoListRow(
            repoName: "Egy repó",
            userName: "TwoStraws",
            imageUrl: "https://avatars.githubusercontent.com/u/190200?v=4")
    }
}
