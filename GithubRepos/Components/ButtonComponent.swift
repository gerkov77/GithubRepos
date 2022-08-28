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
    init(action: @escaping () -> Void, text: String) {
        self.action = action
        self.text = text
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
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

struct ButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponent(action: {}, text: "Button")
    }
}
