//
//  UserOverView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 28/07/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI


struct UserOverView: View {
 
    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    @Environment(\.presentationMode) var presentationMode

    @State private var accounts = [Account]()
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    let barTitle = NSLocalizedString("Account overview", comment: "UserOverView")

    var body: some View {
        NavigationView {
            Form {
                List {
                    ForEach(accounts) {
                        account in
                        HStack {
                            if account.image != nil {
                                Image(uiImage: account.image!)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                            Text(account.name)
                            Text(account.email)
                        }
                    }
                }
                /// Noen ganger kan det være lurt å legge .id(UUID()) på List for hurtig oppdatering
                /// .id(UUID())
            }
                .navigationBarTitle(Text(barTitle)) // , displayMode: .inline)
                .navigationBarItems(leading:
                    Button(action: {
                        /// Rutine for å friske opp personoversikten
                        self.refresh()
                    }, label: {
                        Text("Refresh")
                            .foregroundColor(.none)
                    })
            )
        }
        .onAppear {
            self.refresh()
        }
            
            
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.none)
                    })
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                    Spacer()
                }
            }
        )
    }
    
    /// Rutine for å friske opp bildet
    func refresh() {
        /// Sletter alt tidligere innhold i person
        self.accounts.removeAll()
        /// Fetch all persons from CloudKit
        let predicate = NSPredicate(value: true)
        CloudKitAccount.fetchAccount(predicate: predicate)  { (result) in
            switch result {
            case .success(let account):
                self.accounts.append(account)
                self.accounts.sort(by: {$0.name > $1.name})
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }
    
}
