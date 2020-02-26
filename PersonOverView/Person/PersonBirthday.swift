//
//  PersonBirthday.swift
//  PersonOverView
//
//  Created by Jan Hovland on 26/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct PersonBirthday: View {

    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    @State private var persons = [Person]()
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    var barTitle = NSLocalizedString("Birthday overview", comment: "PersonBirthday")
    

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                List {
                    ForEach(persons) {
                        person in
                        NavigationLink(destination: PersonView(person: person)) {
                            ShowPersonBirthday(person: person)
                        }
                    }
                }
            }
            .navigationBarTitle(Text(barTitle)) //, displayMode: .inline)
        }
        .onAppear {
            self.refresh()
        }
    }

    /// Rutine for å friske opp bildet
    func refresh() {
        /// Sletter alt tidligere innhold i person
        self.persons.removeAll()
        /// Fetch all persons from CloudKit
        let predicate = NSPredicate(value: true)
        CloudKitPerson.fetchPerson(predicate: predicate)  { (result) in
            switch result {
            case .success(let person):
                self.persons.append(person)
                /// Sortering
                self.persons.sort(by: {$0.lastName < $1.lastName})
                self.persons.sort(by: {$0.firstName < $1.firstName})
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

}

/// Et eget View for å vise person detail view
struct ShowPersonBirthday: View {

    /* Dato formateringer:
     Wednesday, Feb 26, 2020            EEEE, MMM d, yyyy
     02/26/2020                         MM/dd/yyyy
     02-26-2020 12:30                   MM-dd-yyyy HH:mm
     Feb 26, 12:30 PM                   MMM d, h:mm a
     February 2020                      MMMM yyyy
     Feb 26, 2020                       MMM d, yyyy
     Wed, 26 Feb 2020 12:30:24 +0000    E, d MMM yyyy HH:mm:ss Z
     2020-02-26T12:30:24+0000           yyyy-MM-dd'T'HH:mm:ssZ
     26.02.20                           dd.MM.yy
     12:30:24.423                       HH:mm:ss.SSS
     */

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = " dd.MMMM "
        return formatter
    }()
    var person: Person

    @State private var sendMail = false

    var body: some View {
        HStack (spacing: 20) {
            if person.image != nil {
                Image(uiImage: person.image!)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
            }
            Text("\(person.dateOfBirth, formatter: Self.taskDateFormat)")
                .background(Color(.green))
                .foregroundColor(.black)
                .font(.custom("Courier", size: 16))
            Spacer()
            Text(person.firstName)
            Image("message")
                .resizable()
                .frame(width: 30, height: 30, alignment: .leading)
        }
        .onLongPressGesture {
             self.sendMail.toggle()
        }
        .sheet(isPresented: $sendMail) {
            PersonSendMail(person: self.person)
        }
    }
}

