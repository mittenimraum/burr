//
//  OnboardingView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 07.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import AttributedTextView
import SwiftUI
import SwiftUIRouter

struct OnboardingView: View {
    // MARK: - Variables

    var interactor: OnboardingInteractor

    // MARK: - Variables

    @State private var input = String()
    @State private var focus = [false]

    var body: some View {
        GeometryReader { reader in
            List {
                VStack(alignment: .center) {
                    AttributedText(idealWidth:
                        reader.size.width
                            - Interface.Spacing.General.List.leading
                            - Interface.Spacing.General.List.trailing) {
                        Attributer(self.interactor.title)
                            .font(Interface.Fonts.medium?.withSize(Interface.Fonts.Sizes.title))
                            .color(Interface.Colors.primary)
                            .paragraphLineBreakModeWordWrapping
                            .paragraphLineSpacing(Interface.Spacing.Fonts.Regular.leading)
                            .paragraphApplyStyling
                            .match("Twitter")
                            .color(Interface.Colors.secondary)
                    }
                    Spacer(minLength: Interface.Spacing.Onboarding.spacing)
                    HStack {
                        Image(uiImage: "#".image(withAttributes: [
                            .font: UIFont.systemFont(ofSize: Interface.Fonts.Sizes.body, weight: .bold),
                            .foregroundColor: Interface.Colors.primary,
                        ]))
                        TextFieldView(
                            done: { text in
                                self.interactor.done(text)
                            },
                            contentType: .emailAddress,
                            returnVal: .done,
                            font: Interface.Fonts.medium,
                            fontColor: Interface.Colors.primary,
                            placeholder: self.interactor.placeholder,
                            characterSet: self.interactor.validCharacters,
                            minCharacters: 2,
                            tag: 0,
                            text: self.$input,
                            isFocusable: self.$focus
                        )
                    }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                }
                .listRowInsets(Interface.Spacing.Onboarding.padding)
            }
            .padding(EdgeInsets())
        }
        .onAppear {
            self.focus = [true]
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(interactor: OnboardingInteractor(store: AppStore(AppState())))
    }
}
