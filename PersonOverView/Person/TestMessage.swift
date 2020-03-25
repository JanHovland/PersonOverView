//
//  TestMessage.swift
//  PersonOverView
//
//  Created by Jan Hovland on 25/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import MessageUI

/// Main View
struct TestMessage: View {

    var messageRecipients: String
    var messageBody: String

    private let mailComposeDelegate = MailComposerDelegate()

    private let messageComposeDelegate = MessageComposerDelegate()

    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.presentMailCompose()
            }) {
                Text("email")
            }

            Spacer()

           Button(action: {
               self.presentMessageCompose()
           }) {
               Text("Message")
           }
            Spacer()
        }
    }
}

// MARK: The email extension

extension TestMessage {

    private class MailComposerDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    /// Present an mail compose view controller modally in UIKit environment
    private func presentMailCompose() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        let composeVC = MFMailComposeViewController()

        composeVC.mailComposeDelegate = mailComposeDelegate

        vc?.present(composeVC, animated: true)
    }
}

// MARK: The message extension

extension TestMessage {

    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result) {
            case .cancelled:
                print("Message was cancelled")
                /// Retur til TestMessage
                controller.dismiss(animated: true)
            case .failed:
                print("Message failed")
                /// Retur til TestMessage
                controller.dismiss(animated: true)
            case .sent:
                print("Message was sent")
                /// Retur til TestMessage
                controller.dismiss(animated: true)
            default:
                break
            }
        }
    }
    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        /// Tilpasse meldingen:
        /// body: er selve meldingen
        /// recipients: er mottaker(ne)
        composeVC.body = messageBody
        composeVC.recipients = [messageRecipients]
        /// Viser bildet for meldingen
        vc?.present(composeVC, animated: true)
    }
}
