//
//  RepoDetailsScreen.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import SwiftUI

struct RepoDetailsScreen {
    let name: String
    let user: String
    @StateObject var viewModel: RepoDetailsViewModel = RepoDetailsViewModel()
}

extension RepoDetailsScreen: View {
    
    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: URL(string: viewModel.repo?.owner.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } placeholder: {
                    Image("github-120")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .padding()
                }
                .padding(.top, 40)
                .padding(.bottom, 40)

                HStack {
                    Text("Created by: ")
                        .font(Appfonts.medium(size: 17).font)
                    
                    Text(viewModel.repo?.owner.login ?? "")
                        .font(Appfonts.medium(size: 17).font)
                }
                
                HStack  {
                    Text( "Language:")
                        .font(Appfonts.medium(size: 17).font)
                    
                    Text( viewModel.repo?.language ?? "")
                        .font(Appfonts.medium(size: 17).font)
                }
                .padding(4)
                
                
                HStack {
                    Text("Created at: ")
                        .font(Appfonts.medium(size: 17).font)
                    
                    Text(viewModel.repo?.createdAt ?? "")
                        .font(Appfonts.medium(size: 17).font)
                }
                .padding(.bottom, 40)
                
                Text(viewModel.repo?.description ?? "No description available")
                
                Spacer()
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "star")
                }
                .padding(.bottom, 100)
                .navigationTitle(Text(name))
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .onAppear {
            viewModel.fetchRepo(name: name, user: user)
        }
    }
}

struct RepoDetaislScreen_Previews: PreviewProvider {
    static var previews: some View {
        RepoDetailsScreen(name: "vaccinationbooking", user: "gerkov77")
    }
}
