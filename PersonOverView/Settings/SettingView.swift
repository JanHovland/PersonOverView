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
    
    private var SMSChoiseType = [NSLocalizedString("Disable SMS", comment: "SettingView"),
                                 NSLocalizedString("Enable SMS", comment: "SettingView")
    ]
    
    @State private var selectedOptionSMS = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showPassword: Bool = true
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    
    @ObservedObject var settingsStore: SettingsStore = SettingsStore()
    @State var smsChoises: [smsOptions] = [.deaktivert, .aktivert]
    @State var eMailChoises: [eMailOptions] = [.deaktivert, .aktivert]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("PASSWORD", comment: "SettingView"))) {
                    VStack {
                        Toggle(isOn: $settingsStore.showPasswordActivate) {
                            Text(NSLocalizedString("Show password", comment: "SettingView"))
                        }
                    }
                }
                Section(header: Text(NSLocalizedString("POSTALCODE", comment: "SettingView"))) {
                    Button(
                        action: {
                            self.alertIdentifier = AlertID(id: .second)
                    },
                        label: {
                            Text(NSLocalizedString("Delete PostalCode (100 at a time)", comment: "SettingView")
                            )}
                    )
                    Button(
                        action: {
                            self.alertIdentifier = AlertID(id: .third)
                    },
                        label: {
                            Text(NSLocalizedString("Save PostalCode", comment: "SettingView")
                            )}
                    )
                }
                
                Section(header: Text(NSLocalizedString("SMS", comment: "SettingView"))) {
                    VStack {
                        Picker("SMS option", selection: self.$settingsStore.smsOptionSelected) {
                            ForEach(self.smsChoises, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                }
                
                Section(header: Text(NSLocalizedString("EMAIL", comment: "SettingView"))) {
                    VStack {
                        Picker("Email option", selection: self.$settingsStore.eMailOptionSelected) {
                            ForEach(self.eMailChoises, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                }
                
            }
                /// .navigationBarTitle("Settings")
                /// displayMode gir overskrift med små tegn:
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
                        /// .padding(.top, 70)
                        /// Med displayMode
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
                                                                // self.testSave()
                                                                self.UpdatePostalCodeFromCSV()
                                 }),
                                 secondaryButton: .cancel(Text(NSLocalizedString("No", comment: "SettingView"))))
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
