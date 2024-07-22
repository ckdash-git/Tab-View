//
//  FullScreenView.swift
//  Brower Tabs
//
//  Created by Chandan Kumar Dash on 22/07/24.
//

import SwiftUI

struct FullScreenView: View {
    var tab: Tab
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tabTitle: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                })
                Spacer()
                Text(tabTitle)
                    .font(.headline)
                    .padding()
                Spacer()
            }
            
            WebView(tab: tab) { title in
                self.tabTitle = title
            }
            .cornerRadius(15)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
