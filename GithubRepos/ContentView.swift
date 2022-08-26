//
//  ContentView.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 22..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RepoSearchScreen(searchText: "")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            StarredReposListScreen()
                .tabItem {
                    Label("Starred", systemImage: "star")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
