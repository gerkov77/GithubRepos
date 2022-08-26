//
//  RepoListScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 23..
//

import SwiftUI

struct RepoListScreen {
    
    
    @StateObject var viewModel = RepoListViewModel()
    @State var shouldShowDetailScreen: Bool = false
    @State var selectedRepo: Repository?
    var userName: String
    
    init(userName: String) {
        self.userName = userName
    }
}


extension RepoListScreen: View {
    
    
    var body: some View {
        
        Group {
            if viewModel.repos.isEmpty {
                EmptyStateView()
            }
            else {
                    List(selection: $selectedRepo) {
                        VStack {
                            ForEach(viewModel.repos, id: \.id) { repo in
                                RepoListRow(
                                    repoName: repo.name,
                                    userName: repo.owner.login,
                                    imageUrl: repo.owner.avatarUrl
                                )
                                .onTapGesture {
                                    shouldShowDetailScreen = true
                                    selectedRepo =  repo
                                }
                                .sheet(isPresented: $shouldShowDetailScreen) {
                                    RepoDetaislScreen(text: selectedRepo!.name)
                                }
                            }
                        }
                        StateDependentView(userName: userName)
                            .environmentObject(viewModel)
                    }

                .onDisappear {
                    viewModel.resetSearch()
                }
            }
        }
        .onAppear {
            viewModel.fetchRepos(userName: userName)
        }
    }
}

struct RepoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        RepoListScreen(userName: "twostraws")
    }
}


extension RepoListScreen {
    struct StateDependentView: View {
        @EnvironmentObject var viewModel: RepoListViewModel
         let userName: String
        
        var body: some View {
            switch viewModel.state {
            case .idle:
                Color.red
                    .frame(width: 0,height: 0)
                    .onAppear {
                        viewModel.fetchRepos(userName: userName)
                        print("load more")
                    }
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
            case .loadedAll:
                EmptyView()
            case .error(let error):
                Text("Error fetching repos \(error)")
            }
        }
    }
}

