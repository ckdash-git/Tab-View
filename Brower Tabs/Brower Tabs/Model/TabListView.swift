//
//  TabListView.swift
//  Brower Tabs
//
//  Created by Chandan Kumar Dash on 22/07/24.
//

import SwiftUI

struct TabsListView: View {
    @Binding var tabs: [Tab]
    @Binding var selectedTab: Tab?
    
    var body: some View {
        NavigationView {
            List(tabs) { tab in
                Button(action: {
                    withAnimation {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.tabURL)
                }
            }
            .navigationTitle("Opened Tabs")
            .navigationBarItems(trailing: Button("Close") {
                // Action to close the view
            })
        }
    }
}
