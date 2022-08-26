//
//  RepoDetailsScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import SwiftUI

struct RepoDetailsScreen {
    let name: String
}

extension RepoDetailsScreen: View {
    
    var body: some View {
        Text(name)
            .background(Color.red)
    }
}

struct RepoDetaislScreen_Previews: PreviewProvider {
    static var previews: some View {
        RepoDetailsScreen(name: "Some text")
    }
}
