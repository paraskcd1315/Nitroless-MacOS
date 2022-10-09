//
//  SwiftUIView.swift
//  Nitroless
//
//  Created by Paras KCD on 2022-10-08.
//

import SwiftUI
import WebKit

struct GIFView: NSViewRepresentable {
    typealias NSViewType = WKWebView
    
    let request: URLRequest
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.load(request)
    }
}

