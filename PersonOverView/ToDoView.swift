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
  1. 🔴 Vise kart
  2. 🔴 Ringe
  1. 🔴 Sende melding
  2. 🔴 Sende e-post
  3. 🔴 Legge inn fødselsdaglisten fra Firebase

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
 34. 🟠 Legge inn postnummer i CloudKit:
        a) 🟢 Opprette tabellen i "PostalCode"
        b) 🟢 Legger csv filen fra Bring inn i prosjektet
        c) 🔴 Lage func for å slette hele inholdet i "PostalCode" tabellen
               1) 🟢 Nå slettes kun 100 om gangen, endre til å kunne slette alle samtidig
        d) 🟢 Legge nytt view fra Settings for å oppdatere "PostalCode" tabellen
        e) 🟢 Lage func for å lese fra csv filen
        f) 🟢 Lage func for å lagre i "PostalCode" tabellen. Status: OK !!!!
              1) 🟢 Alle 5093 (tid: 34 minutter)
              2) 🟢 1000
              3) 🟢 2700
 35.  🟢 Lage func for henting fra "PostalCode" tabellen mhv. predicate
 36.  🟢 Markere personer som har fødselsdag i inneværende måned (.background )
 37 . 🟢 Benytte ActionSheet (se på slutten av "SettingsView")
         a) 🟢 "Slette bruker"
         b) 🟢 "Endre bruker"
 38.  🟢 Lagt inn var dateMonthDay: String = "" /// format 0226 == MMdd men ny func: MonthDay(date: Date) -> String
 39.  🟢 Adressen har stor bokstav i hvert ord ved .autocapitalization(.words)
 40.  🟢 Slette bilde ved ny person (henger igjen fra forrige gang)
         Lagt inn i .onAppear: ImagePicker.shared.image = nil
 41.  🟢 Tatt bort in: for ubegrenset dato utvalg for å kunne legge inn fødselsdag (med dag og måned større enn dagens dag ogmåned).
         Selv med dato frem i tid resettes dag og måned tilbake til dagens dag og måned
 42.  🟢 "Ny person" : Postkode kan ikke slå opp postnummer for en ny person før denne personen kalles opp igjen fra "Oversikt"
         a) 🟢 Laget funksjon ("FindPostalCodeNewPerson") med nput "Sted" og returnerer "postnummer", "kommunenummer" og "kommunenavn"
         b) 🟢 "Oppdater person": Nå oppdateres kun når en trykker "Endre" (i dag lagres endringen når en endrer postnummer)
         c) 🟢 Legg inn avslutning ("Chevron") på "FindPostalCodeNewPerson"
         d) 🟢 Kun valg når Cityname.count > 0
 43.  🟢 Får nå spørsmål om sletting i "Oversikt personer"
         a) 🟢 Benytter nå ActionSheet
 44.  🟢 Formatterer nå telefonnummeret i "InputTextField" med ny parameter "checkPhone"
 45.  🟢 Skjuler nå "Frisk opp" før en velger "Sted (postnummer)
         a) 🟢 "Ny person"
         b) 🟢 "Vedlikehold"
 46.  🟢 Kan nå trykke flere ganger på "Lagre".
         a) 🟢 Bytter "Lagre" til "Endre" etter å ha valgt "Lagre" for andre gang
               Måtte finne recordID etter å ha lagret en ny person.
 47.  🟢 "NewPersonView" : Hvis ikke det er valgt bilde, og trykker "Lagre", så vises det et blankt bilde i "Oversikt"
         a) 🟢 Hvis det er valgt et bilde, vises dette korrekt i "Oversikt"
 48.  🟢 Viser nå et blankt bilde i "Oversikt"
 49.  🟢 Lagt inn refresh i "Fødselsdager"
 50.  🟢 Viser nå alder i "Fødselsdager"
 51.  🟢 Sjekk sortering (Ågot/Ørjan) i "Oversikt"
         Det viser seg at dersom en setter en emoji som 1. tegn når En legger inn formavn som begynner på "Å".
         blir sorteringen riktig.
         a) Lagd en func TextDeleteFirstEmoji() som sjekker om første tegn er en emoji og viser kun alle tegn etter emojien.
 52.  🟢 "Ny Person" Finner nå recordID etter at personen er lagret mha. FetchPerson siden "Lagre" har recordID == nil
         I tillegg kommer det opp et varsel dersom recordID == nil
 53.  🟢 "Ny person" kan lagre en ny person 2 ganger.
         Løsning: legge inn  self.saveNumber += 1 foran "Lagre"
 54.  🟢 Forbedret søking på "Oversikt" med hensyn til tastaturet som er i veien, ved å Legge inn "Avbryt".
 55.  🟢 Modify "Person" : Når en trykker på et felt forsvinner alle feltene, bortsett fra fødselsdato og kjønn
         Feilen kommer fra: .modifier(AdaptsToSoftwareKeyboard()) som jeg kommenterte bort i "PersonView"
 56.  🟢 Nå kan kartet vise hvor en person bor
 57.  🟢 Nå kan det ringes en person


"""
var toDo_4 =
"""
S e n e r e

"""
var toDo_5 =
"""
  1.  🔴 Trykke på bildet istedet for på teksten i "SignUpView.swift"
  2.  🔴 .onDisappear: Få opp spørsel om lagring etter å ha trykket "Vis persondata" og så return til "Oversikt"
         a) Dersom en har endret et felt/image og en så trykker "<Oversikt" må det komme spørsmål om lagring
  3.  🔴 .onDisappear: Få opp spørsel om lagring etter å ha trykket "Ny person" og så retur til "Oversikt"
         a) Dersom en har endret et felt/image og en så trykker "<Oversikt" må det komme spørsmål om lagring

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
  4. Vanlig sorteing tar ikke hensyn til local region slik den gjør i UIKit.

"""

struct ToDoView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var toDo = NSLocalizedString("To do", comment: "ToDoView")

    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack {
                    Text(toDo_0)
                        .font(.custom("Andale Mono Normal", size: 20)).bold()
                        .foregroundColor(.accentColor)
                    Text(toDo_1)
                        .font(.custom("Andale Mono Normal", size: 14))
                        .multilineTextAlignment(.leading)
                    Text(toDo_2)
                        .font(.custom("Andale Mono Normal", size: 20)).bold()
                        .foregroundColor(.accentColor)
                    Text(toDo_3)
                        .font(.custom("Andale Mono Normal", size: 14))
                        .multilineTextAlignment(.leading)
                    Text(toDo_4)
                        .font(.custom("Andale Mono Normal", size: 20)).bold()
                        .foregroundColor(.accentColor)
                    Text(toDo_5)
                        .font(.custom("Andale Mono Normal", size: 14))
                        .multilineTextAlignment(.leading)
                    Text(toDo_6)
                        .font(.custom("Andale Mono Normal", size: 20)).bold()
                        .foregroundColor(.red)
                    Text(toDo_7)
                        .font(.custom("Andale Mono Normal", size: 14))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.red)
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

