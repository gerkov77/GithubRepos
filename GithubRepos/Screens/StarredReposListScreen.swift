//
//  StarredReposListScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 23..
//

import SwiftUI

struct StarredReposListScreen: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 1) {
                    ForEach(Repository.allMockRepos, id: \.id) { repo in
                        RepoListRow(
                            repoName: repo.name,
                            userName: repo.owner.login,
                            imageUrl: repo.owner.avatarUrl
                        )
                    }
                    
                }
            }
            .navigationTitle("Starred repos")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StarredReposListScreen_Previews: PreviewProvider {
    static var previews: some View {
        StarredReposListScreen()
    }
}
