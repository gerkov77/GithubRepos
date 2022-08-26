//
//  StarredReposListScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 23..
//

import SwiftUI

struct StarredReposListScreen {
    @StateObject var viewModel: StarredReposViewModel = StarredReposViewModel()
}

extension StarredReposListScreen: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 1) {
                    if let repos = viewModel.repos {
                        
                        ForEach(repos, id: \.id) { repo in
                            RepoListRow(
                                repoName: repo.name,
                                userName: repo.owner?.login ?? "",
                                imageUrl: repo.owner?.avatarUrl ?? ""
                            )
                        }
                    }
                }
            }
            .navigationTitle("Starred repos")
            .onAppear {
                viewModel.fetchRepos()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StarredReposListScreen_Previews: PreviewProvider {
    static var previews: some View {
        StarredReposListScreen()
    }
}
