//
//  ShareViewController.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//

import SwiftUI

struct ShareViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareViewController>) ->
        UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
               applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
               context: UIViewControllerRepresentableContext<ShareViewController>) {
        // empty
    }
}
