//
//  ToDoView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 30/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI

var toDo_0 =
"""
E n d r i n g e r
"""

var toDo_1 =
"""
  1. Legge inn postnummer i CloudKit:
     a) Legg data inn i CloudKit i som CKAsset i en tabell?
     b) Bruke samme metode som jeg brukte i Firebase?
     c) Lage en link til postnummer.csv i "Filer" på iPhone
        La denne linken være parameter til appen som sletter og
        så oppdaterer postnummer tabellen
  2. Legge inn fødselsdaglisten fra Firebase
  3. Lagre søkebilde for postnummer
"""

var toDo_2 =
"""
F e r d i g
"""

var toDo_3 =
"""
  1. Reduserte meldinger i SignInView.swift
  2. Reduserte meldinger i SignUpView.swift
  3. Ta bort "online keyboard"
    ... Lagt inn .modifier(DismissingKeyboard())
  4. Reduserer nå størrelsen på bildet som blir lagret på CloudKit.
  5. Viser nå kun lagret bilde i CloudKit.
    ... Uten lagret bilde vises et blankt bilde i SignInView.swift
  6. Endre "Feil e-Post eller passord" til "Ukjent ...."
  7. Endret fra UserMaintenanceView().environmentObject(User()
    til : UserMaintenanceView().environmentObject(self.user)
  8. Ny .sheet som inneholder :
     a) Endre profil bilde
     b) Endre navn
     c) Endre e-post
     d) Endre passord
  9. Lagt inn "slett bruker" meny
 10. "Sign up" -> Registrer(ing)
 11. Blanke feltene etter:
     a) "Meld deg inn"
     b) "Slett"
 12. "Innlogging CloudKit":
     a) "Bruker vedlikehold" går tilbake til "Innlogging CloudKit"
        Løsning: Flytte .sheet rett etter hver "Button"
 13. Lagt inn .alert med spørsmål på:
     a) "UserMaintenanceView.swift"
     b) "UserDeleteView.swift"
 14. .alert kan bare legges inn en gang
     a) Lagt inn: struct AlertID
 15. Ta bort Scroll indicators:
     a) Løsning: ScrollView (.vertical, showsIndicators: false)
 16. Må skjule "Meny valg" før innlogging
     a) Løsning: .opacity(showOptionMenu ? 1 : 0)
        og showOptionMenu settes til true når en finner brukeren
 17. Personbildet har nå bilde av personen
 18. Har lagd en liste (tableview) over alle personene
 19. Lagt inn knapp "Ny bruker" for kopling til "NewPersonView bildet"
 20. Lagt inn knapp for lagring av ny person i "PersonOverView"
 21. Lagt inn knapp "Frisk opp" med oppfriskning funksjon
 22. Endring av for- og etternavn er nå riktig
 23. Sletting fjerner nå fra listen og i CloudKit
 24. "Vis passord" har nå korrekt visning
 25. "person.dateOfBirth" vises nå som DD.MM.YYYY
 26. Ryddet opp i visningen i "PersonOverView"
 27. Bruker nå .autocapitalization(.sentences) på adresse feltene
 28. Lagt inn "Ny bruker" på oppstartsbildet "Logg inn"
 29. Legt inn sortering på fornavn-etternavn i "CloudKitPerson.fetchPerson"
 30. Lagt inn søke felt i "PersonOverView" og
     søker nå etter søketeksten i for- og/eller etternavnet
 31  Norsk sortering på Oversikt
 32. Oppdatering Person: Etternavn og epost forsvinner.
     Dette skjer først når en avslutter utvalg på dato.
     Ser ut som det hadde sammenheng med forrige versjon av iOS (17D50 bruker nå 17E5223h)
 33. Tatt bort scrollbar på: Person og Oversikt Person ved hjelp av:
     UITableView.appearance().showsVerticalScrollIndicator = false

"""

var toDo_4 =
"""
S e n e r e
"""

var toDo_5 =
"""
1. Trykke på bildet istedet for på teksten i "SignUpView.swift"
   ... Bruk: .contextMenu??
2. Legge inn søking på postnummer
"""

var toDo_6 =
"""
K j e n t e   f e i l
"""

var toDo_7 =
"""
1. Når en bytter showPassword, oppdateres ikke "SignInView.swift" automatisk.
   a) Foreløpig løsning: Skift til "SignUpView.swift" og så
      tilbake til "SignInView.swift" (implementere refresh)
2. onAppear virker kun første gang en app kalles,
   ikke ved retur fra en annen app. (implementere refresh)
3. Det mangler .keyboadType(.phone).
   a) Nå brukes default keyboardType

"""

struct ToDoView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var toDo = NSLocalizedString("To do", comment: "ToDoView")

    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack {
                    Text(toDo_0)
                        .font(.custom("system", size: 17)).bold()
                        .foregroundColor(.accentColor)
                        .padding()
                    Text(toDo_1)
                        .multilineTextAlignment(.leading)
                    Text(toDo_2)
                        .font(.custom("system", size: 17)).bold()
                        .foregroundColor(.accentColor)
                        .padding()
                    Text(toDo_3)
                        .multilineTextAlignment(.leading)
                    Text(toDo_4)
                        .font(.custom("system", size: 17)).bold()
                        .foregroundColor(.accentColor)
                        .padding()
                    Text(toDo_5)
                        .multilineTextAlignment(.leading)
                    Text(toDo_6)
                        .font(.custom("system", size: 17)).bold()
                        .foregroundColor(.accentColor)
                        .padding()
                    Text(toDo_7)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .navigationBarTitle(NSLocalizedString(toDo, comment: "ToDoView"))
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
}

