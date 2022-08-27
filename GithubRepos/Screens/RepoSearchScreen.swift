//
//  RepoSearchScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 22..
//

import SwiftUI

struct RepoSearchScreen: View {
    
    @State var searchText: String
    @State var shouldShowRepoList = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                Image("github-120")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 120, height: 120, alignment: .center)
                    .padding()
                
                Text("Github Repos")
                    .font(.custom("Helvetica Neue Bold", fixedSize: 30))
                
                Spacer(minLength: 0)
                
                TextField("Type a username for their repos", text: $searchText)
                    .padding()
                    .background(Color(uiColor: .systemFill))
                    .cornerRadius(10)
                    .padding()
                    .autocapitalization(.none)
                
                Spacer()
                
                NavigationLink(isActive: $shouldShowRepoList) {
                    RepoListScreen(userName: searchText)
                } label: {
                    EmptyView()
                }
                
                ButtonComponent(action: {
                    shouldShowRepoList = true
                }, text: "Search repos")
                .padding()
                .disabled(searchText.isEmpty)
            }
            .padding()
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct RepoSearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        RepoSearchScreen(searchText: "")
    }
}
