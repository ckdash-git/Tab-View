//
//  WebView.swift
//  Brower Tabs
//
//  Created by Chandan Kumar Dash on 22/07/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var tab: Tab
    var onTitleChange: (String) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: tab.tabURL) {
            webView.load(URLRequest(url: url))
        }
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update web view settings or content here if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTitleChange: onTitleChange)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var onTitleChange: (String) -> Void
        
        init(onTitleChange: @escaping (String) -> Void) {
            self.onTitleChange = onTitleChange
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let title = webView.title {
                onTitleChange(title)
            }
        }
    }
}
