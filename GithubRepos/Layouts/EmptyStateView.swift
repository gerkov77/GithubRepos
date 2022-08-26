//
//  EmptyStateView.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import SwiftUI


struct EmptyStateView: View {
    
    var body: some View {
        VStack {
            Image("empty-state-logo")
                .resizable()
                .frame(width: 300, height: 300)
            Text("No repos yet...😕")
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
    }
}
