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

    @Environment(\.presentationMode) var presentationMode

    @State private var persons = [Person]()
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    let barTitle = NSLocalizedString("Birthday", comment: "PersonBirthday")

    var body: some View {
        NavigationView {
            Form {
                List {
                    ForEach(persons) {
                        person in
                        NavigationLink(destination: PersonView(person: person)) {
                            ShowPersonBirthday(person: person)
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
                        .padding(.trailing, 28)
                        .padding(.top, 70) 
                    Spacer()
                }
            }
        )

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
                self.persons.sort(by: {$0.firstName < $1.firstName})
                self.persons.sort(by: {$0.dateMonthDay < $1.dateMonthDay})
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

}

/// Et eget View for å vise person detail view
struct ShowPersonBirthday: View {

    var person: Person
    var removeChar: String = "✈️"

    @State private var sendMail = false

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
        formatter.dateFormat = "dd. MMMM"
        return formatter
    }()

    var age: String {
        /// Finner aktuell måned
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "yy"
        let year = Calendar.current.component(.year, from: currentDate)

        /// Finner måned fra personen sin fødselsdato
        let personDate = person.dateOfBirth
        let personFormatter = DateFormatter()
        personFormatter.dateFormat = "yy"
        let yearPerson = Calendar.current.component(.year, from: personDate)

        return String(year - yearPerson)
    }

    var colour: Color {
        /// Finner aktuell måned
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"
        let month = Calendar.current.component(.month, from: currentDate)

        /// Finner måned fra personen sin fødselsdato
        let personDate = person.dateOfBirth
        let personFormatter = DateFormatter()
        personFormatter.dateFormat = "MMMM"
        let monthPerson = Calendar.current.component(.month, from: personDate)

        /// Endrer bakgrunnsfarge dersom personen er født i inneværende måned
        if monthPerson == month {
            return Color(.systemGreen)
        }
        return Color(.clear)
    }

    var body: some View {
        HStack (spacing: 10) {
            if person.image != nil {
                Image(uiImage: person.image!)
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
            Text("\(person.dateOfBirth, formatter: Self.taskDateFormat)")
                .background(colour)
                .font(.custom("Andale Mono Normal", size: 16))
            Text(age)
                .foregroundColor(.accentColor)
            TextDeleteFirstEmoji(firstName : person.firstName)
            .font(Font.body.weight(.ultraLight))
            Spacer(minLength: 5)
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

