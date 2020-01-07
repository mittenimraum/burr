//
//  FeedView.swift
//  SwiftUIArchitecture
//
//  Created by Stephan Schulz on 08.01.20.
//  Copyright © 2020 Stephan Schulz. All rights reserved.
//

import Store
import SwiftUI
import SwiftUIRouter

struct FeedView: View {
    var interactor: FeedInteractable
    var body: some View {
        Text("Feed")
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(interactor: FeedInteractor(store: Store<AppState>(model: AppState())))
    }
}
