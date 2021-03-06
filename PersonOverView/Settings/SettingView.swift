//
//  SettingView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 07/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import Combine

enum smsOptions: String, CaseIterable {
    case deaktivert = "Deaktivert"
    case aktivert = "Aktivert"
}

enum eMailOptions: String, CaseIterable {
    case deaktivert = "Deaktivert"
    case aktivert = "Aktivert"
}

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showPassword: Bool = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    
    @ObservedObject var settingsStore: SettingsStore = SettingsStore()
    
    @State var smsChoises: [smsOptions] = [.deaktivert, .aktivert]
    @State var eMailChoises: [eMailOptions] = [.deaktivert, .aktivert]
    
    var body: some View {
        NavigationView {
           Form {
                /// Vis passord av/på
                NavigationLink(destination: Password()) {
                    HStack {
                        Image("switch")
                            .resizable()
                            .frame(width: 35, height: 43)
                        Text(NSLocalizedString("Password", comment: "SettingView"))
                    }
                }
                
                /// Oppdatere postnummer
                NavigationLink(destination: PostalCodeUpdate(alertIdentifier: $alertIdentifier)) {
                    HStack {
                        Image("postalCode")
                            .resizable()
                            .frame(width: 35, height: 45)
                        Text("Postalcode")
                    }
                }

                /// Sende teksmelding
                NavigationLink(destination: EMail(eMailChoises: eMailChoises,
                                                  alertIdentifier: $alertIdentifier,
                                                  message: $message,
                                                  settingsStore: settingsStore)) {
                    HStack {
                        Image("mail")
                            .resizable()
                            .frame(width: 35, height: 35)
                        Text("Email")
                    }
                }
           
                /// Sende e-post
                NavigationLink(destination: Message(smsChoises: smsChoises,
                                                    alertIdentifier: $alertIdentifier,
                                                    message: $message,
                                                    settingsStore: settingsStore)) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("message")
                            .resizable()
                            .frame(width: 29, height: 29)
                        Text("SMS")
                    }
                    .padding(.leading, 3)
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
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
                    .padding(.top, 15)
                    Spacer()
                }
            }
        )

        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(NSLocalizedString("Delete PostalCode", comment: "SettingView")),
                             message: Text(NSLocalizedString("Are you sure you want to delete PostalCode?", comment: "SettingView")),
                             primaryButton: .destructive(Text(NSLocalizedString("Yes", comment: "SettingView")),
                                                         action: {
                                                            CloudKitPostalCode.deleteAllPostalCode()
                             }),
                             secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
            case .third:
                return Alert(title: Text(NSLocalizedString("Save PostalCode", comment: "SettingView")),
                             message: Text(NSLocalizedString("Are you sure you want to save PostalCodes?", comment: "SettingView")),
                             primaryButton: .destructive(Text(NSLocalizedString("Yes", comment: "SettingView")),
                                                         action: {
                                                            self.UpdatePostalCodeFromCSV()
                             }),
                             secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
            }
        }
        
    }
    
    struct Password: View {
        @ObservedObject var settingsStore: SettingsStore = SettingsStore()
        @Environment(\.presentationMode) var presentationMode
        var body: some View {
            Form {
                Section(header: Text(NSLocalizedString("PASSWORD", comment: "SettingView")),
                        footer: Text(NSLocalizedString("Choose to show or hide the password", comment: "SettingView"))) {
                            Toggle(isOn: $settingsStore.showPasswordActivate) {
                                Text(NSLocalizedString("Show password", comment: "SettingView"))
                            }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Password", comment: "SettingView")), displayMode: .inline)
        }
    }

    struct PostalCodeUpdate: View {
        @Binding var alertIdentifier: AlertID?
        @ObservedObject var settingsStore: SettingsStore = SettingsStore()
        @Environment(\.presentationMode) var presentationMode
        var body: some View {
            Form {
                Section(header: Text(NSLocalizedString("POSTALCODE", comment: "SettingView")),
                        footer: Text(NSLocalizedString("Select either delete or update the Postalcode", comment: "SettingView"))) {
                    Text(NSLocalizedString("Delete PostalCode (100 at a time)", comment: "SettingView"))
                        .onTapGesture {
                            self.alertIdentifier  = AlertID(id: .second)
                    }
                    .foregroundColor(.accentColor)
                    Text(NSLocalizedString("Save PostalCode", comment: "SettingView"))
                        .onTapGesture {
                            self.alertIdentifier  = AlertID(id: .third)
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Postal Code", comment: "SettingView")), displayMode: .inline)
        }
    }
    
    struct EMail: View {
        var eMailChoises: [eMailOptions] = [.deaktivert, .aktivert]
        @Binding var alertIdentifier: AlertID?
        @Binding var message: String
        @ObservedObject var settingsStore: SettingsStore = SettingsStore()
        
        var body: some View {
            Form {
                Section(header: Text(NSLocalizedString("EMAIL", comment: "SettingView")),
                        footer: Text(NSLocalizedString("You must activate the email in order to send an email", comment: "SettingView"))) {
                    Picker(NSLocalizedString("Email option", comment: "SettingView"), selection: self.$settingsStore.eMailOptionSelected) {
                        ForEach(self.eMailChoises, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    Button(action: {
                        let value = SendEmail()
                        if value == false {
                            self.message = NSLocalizedString("You must activate the Email option", comment: "SettingView")
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }, label: {
                        Text(NSLocalizedString("Send Email", comment: "SettingView"))
                    })
                }
                .navigationBarTitle(Text(NSLocalizedString("Email", comment: "SettingView")), displayMode: .inline)
            }
        }
    }
        
    struct Message: View {
        var smsChoises: [smsOptions] = [.deaktivert, .aktivert]
        @Binding var alertIdentifier: AlertID?
        @Binding var message: String
        @ObservedObject var settingsStore: SettingsStore = SettingsStore()
        var body: some View {
            Form {
                Section(header: Text(NSLocalizedString("MESSAGE", comment: "SettingView")),
                        footer: Text(NSLocalizedString("You must activate the message in order to send a message", comment: "SettingView"))) {
                    Picker(NSLocalizedString("Message option", comment: "SettingView"), selection: self.$settingsStore.smsOptionSelected) {
                        ForEach(self.smsChoises, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    Button(action: {
                        let value = SendSMS()
                        if value == false {
                            self.message = NSLocalizedString("You must activate the message option", comment: "SettingView")
                            self.alertIdentifier = AlertID(id: .first)
                        }
                    }, label: {
                        Text(NSLocalizedString("Send Message", comment: "SettingView"))
                    })
                }
                .navigationBarTitle(Text(NSLocalizedString("Message", comment: "SettingView")), displayMode: .inline)
            }
        }
    }
    
    func parseCSV (contentsOfURL: URL,
                   encoding: String.Encoding,
                   delimiter: String) -> [(PostalCode)]? {
        
        /// Hvis denne feilmeldingen kommer : Swift Error: Struct 'XX' must be completely initialized before a member is stored to
        /// endre til : var postalCode: PostalCode! = PostalCode()
        var postalCode: PostalCode! = PostalCode()
        var postalCodes: [(PostalCode)]?
        
        do {
            let content = try String(contentsOf: contentsOfURL,
                                     encoding: encoding)
            postalCodes = []
            let lines: [String] = content.components(separatedBy: .newlines)
            for line in lines {
                var values:[String] = []
                if line != "" {
                    values = line.components(separatedBy: delimiter)
                    postalCode.postalNumber = values[0]
                    postalCode.postalName = values[1]
                    postalCode.municipalityNumber = values[2]
                    postalCode.municipalityName = values[3]
                    postalCode.categori = values[4]
                    postalCodes?.append(postalCode)
                }
            }
        } catch {
            print(error)
        }
        return postalCodes
    }
    
    func testSave() {
        var number = 1
        let maxNumber = 51
        var postalCode: PostalCode! = PostalCode()
        
        repeat {
            postalCode.postalNumber = "1"
            CloudKitPostalCode.savePostalCode(item: postalCode) { (result) in
                switch result {
                case .success:
                    _ = 1
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            number += 1
        } while number < maxNumber
        print("Poster lagret: \(number-1)")
    }
    
    func UpdatePostalCodeFromCSV() {
        
        var index = 0
        /// Finner URL fra prosjektet
        guard let contentsOfURL = Bundle.main.url(forResource: "Postnummerregister-ansi", withExtension: "txt") else { return }
        /// Må bruke encoding == ascii (utf8 virker ikke)
        let postalCodes = parseCSV (contentsOfURL: contentsOfURL,
                                    encoding: String.Encoding.ascii,
                                    delimiter: "\t")
        let maxNumber =  postalCodes!.count
        repeat {
            let postalCode = postalCodes![index]
            CloudKitPostalCode.savePostalCode(item: postalCode) { (result) in
                switch result {
                case .success:
                    _ = 1
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            index += 1
        } while index < maxNumber
        print("Poster lagret: \(index)")
    }
}

final class SettingsStore: ObservableObject {
    
    let showPasswordIsActivate = PassthroughSubject<Void, Never>()
    
    var showPasswordActivate: Bool = UserDefaults.showPassword {
        willSet {
            UserDefaults.showPassword = newValue
            showPasswordIsActivate.send()
        }
    }
    
    let smsOption = PassthroughSubject<Void, Never>()
    
    var smsOptionSelected: smsOptions = UserDefaults.smsOption {
        willSet {
            UserDefaults.smsOption = newValue
            smsOption.send()
        }
    }
    
    let eMailOption = PassthroughSubject<Void, Never>()
    
    var eMailOptionSelected: eMailOptions = UserDefaults.eMailOption {
        willSet {
            UserDefaults.eMailOption = newValue
            eMailOption.send()
        }
    }
}

extension UserDefaults {
    
    static var showPassword: Bool {
        get { return UserDefaults.standard.bool(forKey: "showPassword") }
        set { UserDefaults.standard.set(newValue, forKey: "showPassword") }
    }
    
    static var smsOption: smsOptions {
        
        get {
            if let smsOptionValue = UserDefaults.standard.string(forKey: "smsOptionSelected"),
                let type = smsOptions(rawValue: smsOptionValue) {
                return type
            } else {
                return smsOptions(rawValue: "Deaktivert")!
            }
        }
        
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "smsOptionSelected") }
    }
    
    static var eMailOption: eMailOptions {
        
        get {
            if let eMailOptionValue = UserDefaults.standard.string(forKey: "eMailOptionSelected"),
                let type = eMailOptions(rawValue: eMailOptionValue) {
                return type
            } else {
                return eMailOptions(rawValue: "Deaktivert")!
            }
        }
        
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "eMailOptionSelected") }
    }
}
