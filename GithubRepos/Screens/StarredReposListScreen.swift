//
//  StarredReposListScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 23..
//

import SwiftUI

struct StarredReposListScreen {
    @StateObject var viewModel: StarredReposViewModel = StarredReposViewModel()
    @State var shouldShowDetailScreen: Bool = false
    @State var selectedRepo: StarredRepo?
}

extension StarredReposListScreen: View {
    
    var body: some View {
        NavigationView {
            List {
                VStack(spacing: 1) {
                    if let repos = viewModel.repos {
                        
                        ForEach(repos, id: \.id) { repo in
                            
                            RepoListRow(
                                repoName: repo.name,
                                userName: repo.owner?.login ?? "",
                                imageUrl: repo.owner?.avatarUrl ?? ""
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                shouldShowDetailScreen = true
                                selectedRepo =  repo
                            }
                            .sheet(isPresented: $shouldShowDetailScreen) {
                                RepoDetailsScreen(name: selectedRepo?.name ?? "", user: (selectedRepo?.owner?.login) ?? "")
                            }
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
