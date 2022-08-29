# GithubRepos

## A demo project

GitHubRepos is a SwiftUI application.
It uses the async await api for network calls.
No third libraries are used.
It uses CoreData for persising data.
Combine is used for filtering data.

### Description

GithubRepos Makes an API call to api.github.com to fetch public repos based on the typed username and diplays it in a list.If user taps on a cell, it navigates to a detail view, where user can star the repo - meaning the app will persist the given repo and display it on a dedicated list.
The App uses a TabBar to navigate between the search screen and the starred repos screen, and navigation links to navigate between the lists and the detail view.
User is able to search for repos in the starred repos list using a search  bar on the top of the screen, and delete starred repos from the list.


