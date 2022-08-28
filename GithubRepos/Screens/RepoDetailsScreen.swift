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
    @State var shouldShowAlert: Bool = false
}

extension RepoDetailsScreen: View {
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileSection()
                    .padding(.bottom, 40)
                    .environmentObject(viewModel)
                
                InfoSection()
                    .environmentObject(viewModel)
                
                Spacer()
                
                StarButton(action: {
                    if !viewModel.isStarred {
                        viewModel.addRepo()
                    } else {
                      shouldShowAlert = true
                    }
                }, starred: viewModel.isStarred)
                .clipShape(Rectangle())
                .padding(.bottom, 100)
                .navigationTitle(Text(name))
                .navigationBarTitleDisplayMode(.large)
                .alert(isPresented: $shouldShowAlert) {
                    Alert(
                        title: Text("This repo is already saved"),
                        message: Text("You must really like it 🤩"),
                        dismissButton: .cancel(Text("Ok")))
                }
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

struct InfoSection: View {

    @EnvironmentObject var viewModel: RepoDetailsViewModel
    
    var body: some View {
        HStack {
            Text( "Language:")
                .font(Appfonts.medium(size: 17).font)
            
            Text((viewModel.repo?.language) ?? "could not fetch language")
                .font(Appfonts.medium(size: 17).font)
        }
        .padding(4)
        
        HStack {
            Text("Created at: ")
                .font(Appfonts.medium(size: 17).font)
            
            Text(viewModel.formattedDate)
                .font(Appfonts.medium(size: 17).font)
        }
        .padding(4)

        Text(viewModel.repo?.description ?? "No description available")
            .multilineTextAlignment(.leading)
            .padding(.top, 40)
    }
}

struct ProfileSection: View {
    @EnvironmentObject var viewModel: RepoDetailsViewModel
    
    var body: some View {
        AsyncImage(url: URL(string: (viewModel.repo?.owner.avatarUrl) ?? "")) { image in
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
        
        
        HStack {
            Text("Created by: ")
                .font(Appfonts.medium(size: 17).font)
            
            Text(viewModel.repo?.owner.login ?? "")
                .font(Appfonts.bold(size: 17).font)
        }
    }
}

struct StarButton {
    
    let action: () -> Void
    let starred: Bool
    
    init(action: @escaping () -> Void,
         starred: Bool) {
        self.action = action
        self.starred = starred
    }
}

extension StarButton: View {
    var body: some View {
        Button {
            
            action()
        } label: {
            if starred {
                VStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    
                    Text("Starred")
                        .foregroundColor(.orange)
                }
                
            }
            else {
                VStack {
                    Image(systemName: "star")
                        .foregroundColor(.orange)
                    
                    Text("Add")
                        .foregroundColor(.orange)
                }
            }
        }
    }
}
