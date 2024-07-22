//
//  Home.swift
//  Brower Tabs
//
//  Created by Chandan Kumar Dash on 22/07/24.
//

import SwiftUI

struct Home: View {
    
    // Color Scheme
    @Environment(\.colorScheme) var scheme
    
    // Sample Tabs for demo
    @State var tabs: [Tab] = [
        .init(tabURL: "https://www.google.com/")
    ]
    
    @State private var selectedTab: Tab?
    
    var body: some View {
        ZStack {
            // Background...
            GeometryReader { proxy in
                let size = proxy.size
                Image("BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(0)
            }
            .overlay((scheme == .dark ? Color.black : Color.white).opacity(0.35))
            .overlay(.ultraThinMaterial)
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                // Lazy Grids...
                let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    // Tabs...
                    ForEach(tabs) { tab in
                        // Tab card view...
                        TabCardView(tab: tab, tabs: $tabs, selectedTab: $selectedTab)
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button {
                        withAnimation {
                            tabs.append(Tab(tabURL: "https://www.google.com"))
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            selectedTab = Tab(tabURL: "https://www.google.com")
                        }
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                }
                .overlay(
                    Text("Tabs: \(tabs.count)")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                )
                .padding([.horizontal, .top])
                .padding(.bottom, 10)
                .background(
                    scheme == .dark ? Color.black : Color.white
                )
            }
        }
        .fullScreenCover(item: $selectedTab) { tab in
            FullScreenView(tab: tab)
        }
    }
}

/* ------- The above is Home View and below code is TabCardView. -------*/

#Preview {
    Home()
        .preferredColorScheme(.dark)
}

struct TabCardView: View {
    
    var tab: Tab
    @Binding var tabs: [Tab]
    @Binding var selectedTab: Tab?
    
    @State private var tabTitle = ""
    @State private var offset: CGFloat = 0
    @GestureState private var isDragging: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            WebView(tab: tab) { title in
                self.tabTitle = title
            }
            .frame(height: 250)
            .overlay(Color.primary.opacity(0.01))
            .cornerRadius(15)
            .overlay(
                Button(action: {
                    withAnimation {
                        offset = -(getRect().width + 200)
                        removeTab()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(.ultraThinMaterial, in: Circle())
                })
                .padding(10),
                alignment: .topTrailing
            )
            
            Text(tabTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .frame(height: 50)
        }
        .scaleEffect(getScale())
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    if isDragging {
                        let translation = value.translation.width
                        offset = translation > 0 ? translation / 10 : translation
                    }
                })
                .onEnded({ value in
                    let translation = value.translation.width > 0 ? 0 : -value.translation.width
                    if getIndex() % 2 == 0 {
                        if translation > 100 {
                            withAnimation {
                                offset = -(getRect().width + 200)
                                removeTab()
                            }
                        } else {
                            withAnimation {
                                offset = 0
                            }
                        }
                    } else {
                        if translation > getRect().width - 150 {
                            withAnimation {
                                offset = -(getRect().width + 200)
                                removeTab()
                            }
                        } else {
                            withAnimation {
                                offset = 0
                            }
                        }
                    }
                })
        )
        .onTapGesture {
            withAnimation {
                selectedTab = tab
            }
        }
    }
    
    func getScale() -> CGFloat {
        let progress = (offset > 0 ? offset : -offset) / 50
        let scale = (progress < 1 ? progress : 1) * 0.08
        return 1 + scale
    }
    
    func getIndex() -> Int {
        let index = tabs.firstIndex { currentTab in
            return currentTab.id == tab.id
        } ?? 0
        return index
    }
    
    func removeTab() {
        tabs.removeAll { tab in
            return self.tab.id == tab.id
        }
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

var urls: [String] = [
    "www.cachatto.com",
    "www.cachatto.live",
    "www.ejan.co.jp",
    "www.microsoft.com",
]
