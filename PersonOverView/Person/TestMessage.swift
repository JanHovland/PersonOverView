//
//  TestMessage.swift
//  PersonOverView
//
//  Created by Jan Hovland on 25/03/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import MessageUI

///// Globale variabler for SMS
//var messageRecipients: String = "" 
//var messageBody: String = ""
//
///// Globale variabler for ePost
//var setToRecipients: String = ""
//var setSubject: String = ""
//var setMessageBody: String = ""
//
///// Main View
//struct TestMessage: View {
//
//    @State private var exitMessage = false
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var navTitle = NSLocalizedString("Send eMail or SMS", comment: "TestMessage")
//
//    /// Må ligge slik !!!!
//    private let mailComposeDelegate = MailComposerDelegate()
//    private let messageComposeDelegate = MessageComposerDelegate()
//    var body: some View {
//        NavigationView {
//            VStack {
//                Spacer()
//                Button(action: {
//                    self.presentMailCompose(setToRecipients: setToRecipients,
//                                            setSubject: setSubject,
//                                            setMessageBody: setMessageBody)
//                }) {
//                    HStack {
//                        Image(systemName: "envelope")
//                            .resizable()
//                            .frame(width: 30, height: 30, alignment: .center)
//                        Text(NSLocalizedString("eMail", comment: "TestMessage"))
//                    }
//                }
//                Spacer()
//                Button(action: {
//                    self.presentMessageCompose(messageRecipients: messageRecipients,
//                                               messageBody: messageBody)
//                }) {
//                    HStack {
//                        Image(systemName: "bubble.right")
//                            .resizable()
//                            .frame(width: 30, height: 30, alignment: .center)
//                        Text(NSLocalizedString("Message", comment: "TestMessage"))
//                    }
//                }
//                Spacer()
//                /// Virker ikke, kommer med em feilmelding
//                //            Button(action: {
//                //                self.exitMessage.toggle()
//                //            }) {
//                //                Text("Abort")
//                //            }
//                //            Spacer()
//                /// Virker ikke, kommer med em feilmelding
//                //        .sheet(isPresented: $exitMessage) {
//                //            SignInView()
//                //        }
//            }
//            .navigationBarTitle(navTitle)
//        }
//    }
//}
//
//// MARK: The email extension
//
//extension TestMessage {
//    private class MailComposerDelegate: NSObject, MFMailComposeViewControllerDelegate {
//        func mailComposeController(_ controller: MFMailComposeViewController,
//                                   didFinishWith result: MFMailComposeResult,
//                                   error: Error?) {
//            switch (result) {
//            case .cancelled:
//                print("eMail was cancelled")
//                clearGlobalMail()
//                /// Retur til TestMessage
//                controller.dismiss(animated: true)
//            case .failed:
//                print("eMail failed")
//                clearGlobalMail()
//                /// Retur til TestMessage
//                controller.dismiss(animated: true)
//            case .sent:
//                print("eMail was sent")
//                clearGlobalMail()
//                /// Retur til TestMessage
//                controller.dismiss(animated: true)
//            default:
//                clearGlobalMail()
//                break
//            }
//        }
//    }
//
//    /// Present an mail compose view controller modally in UIKit environment
//    private func presentMailCompose(setToRecipients: String,
//                                    setSubject: String,
//                                    setMessageBody: String) {
//        guard MFMailComposeViewController.canSendMail() else {
//            return
//        }
//
//        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
//
//        let composeVC = MFMailComposeViewController()
//
//        composeVC.mailComposeDelegate = mailComposeDelegate
//
//        /// What does CC mean?
//        /// In email sending, CC is the abbreviation for “carbon copy.” Back in the days before the internet and email, in order to create a copy of the letter you were writing,
//        /// you had to place carbon paper between the paper you were writing on and the paper that was going to be your copy.
//        /// Just as the physical carbon copy above, CC is an easy way of sending copies of an email to other people.
//        /// If you have ever received a CCed email, you’ve probably noticed that it will be addressed to you and a list of other people who have also been CCed.
//
//        /// What does BCC mean?
//        /// BCC stands for blind carbon copy. Just like CC, BCC is a way of sending copies of an email to other people.
//        /// The difference between the two is that, while you can see who else has received the email when CC is used,
//        /// that is not the case with BCC. It is called blind carbon copy  because
//        /// the other recipients won’t be able to see that someone else has been sent a copy of the email.
//
//        /// setToRecipients sjekker om det er angitt en lovlig epost, "jan.hovlandlyse.net" blir vist som blank siden det mangler '@'
//        /// addresses should be specified as per RFC5322
//        composeVC.setToRecipients([setToRecipients])
//        composeVC.setSubject(setSubject)
//        composeVC.setMessageBody(setMessageBody, isHTML: true)
//        vc?.present(composeVC, animated: true)
//    }
//}
//
//func clearGlobalMail() {
//    setToRecipients = ""
//    setSubject = ""
//    setMessageBody = ""
//}
//
//
//// MARK: The message extension
//
//extension TestMessage {
//    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
//        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//            switch (result) {
//            case .cancelled:
//                print("Message was cancelled")
//                clearGlobalMessage()
//                /// Retur til TestMessage
//                controller.dismiss(animated: true)
//            case .failed:
//                print("Message failed")
//                clearGlobalMessage()
//                /// Retur til TestMessage
//                controller.dismiss(animated: true)
//            case .sent:
//                print("Message was sent")
//                clearGlobalMessage()
//                /// Retur til TestMessage
//                controller.dismiss(animated: true)
//            default:
//                clearGlobalMessage()
//                break
//            }
//        }
//    }
//    
//    /// Present an message compose view controller modally in UIKit environment
//    private func presentMessageCompose(messageRecipients: String,
//                                       messageBody: String)        {
//        guard MFMessageComposeViewController.canSendText() else {
//            return
//        }
//        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
//        let composeVC = MFMessageComposeViewController()
//        composeVC.messageComposeDelegate = messageComposeDelegate
//        /// Tilpasse meldingen:
//        /// body: er selve meldingen
//        /// recipients: er mottaker(ne)
//        composeVC.body = messageBody
//        composeVC.recipients = [messageRecipients]
//        /// Viser bildet for meldingen
//        vc?.present(composeVC, animated: true)
//    }
//
//}
//
//func clearGlobalMessage() {
//    messageRecipients = ""
//    messageBody = ""
//}
