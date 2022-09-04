//
//  ButtonComponent.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import SwiftUI

struct ButtonComponent {
    let action: () -> Void
    let text: String
    let isActive: Bool

    init(action: @escaping () -> Void, text: String, isActive: Bool) {
        self.action = action
        self.text = text
        self.isActive = isActive
    }
}

extension ButtonComponent: View {
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(text)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .background(isActive ? Color.blue : Color.gray)
            .cornerRadius(10)
        }
    }
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent(action: {}, text: "Button", isActive: true)
    }
}
