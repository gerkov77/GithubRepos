//
//  StarredReposListScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 23..
//

import SwiftUI

struct StarredReposListScreen {
    @StateObject var viewModel: StarredReposListViewModel = StarredReposListViewModel()
    @State var shouldShowDetailScreen: Bool = false
    @State var selectedRepo: StarredRepoViewModel?
    func deleteRepo(offsets: IndexSet) {
        offsets.forEach { index in
            let repo = viewModel.repos[index]
            viewModel.delete(repo)
        }
    }
    
}

extension StarredReposListScreen: View {

    var body: some View {
        NavigationView {
            List(selection: $selectedRepo) {
                ForEach(viewModel.repos, id: \.self) { repo in
                    RepoListRow(
                        repoName: repo.name,
                        userName: repo.ownerName,
                        imageUrl: repo.avatarUrl
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        shouldShowDetailScreen = true
                        selectedRepo =  repo
                    }
                    .sheet(isPresented: $shouldShowDetailScreen) {
                        RepoDetailsScreen(name: (selectedRepo?.name) ?? "" , user: (selectedRepo?.ownerName) ?? "")
                    }
                }
                .onDelete(perform:  deleteRepo)
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
