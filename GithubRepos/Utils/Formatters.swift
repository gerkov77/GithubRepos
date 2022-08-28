//
//  Formatters.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 28..
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.locale = Calendar.current.locale
    return formatter
}()
