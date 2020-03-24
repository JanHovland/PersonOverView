//
//  PersonsOverView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 29/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit
import Foundation
import MapKit

struct PersonsOverView: View {

    /// Skjuler scroll indicators.
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    @Environment(\.presentationMode) var presentationMode

    @State private var message: String = ""
    @State private var searchText: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var persons = [Person]()
    @State private var newPerson = false
    @State private var deletePersonActinSheet = false
    @State private var personsOverview = NSLocalizedString("Persons overview", comment: "PersonsOverView")
    @State private var indexSetDelete = IndexSet()
    @State private var recordID: CKRecord.ID?


    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .keyboardType(.asciiCapable)
                List  {
                    /// Søker etter personer som inneholder $searchText i for- eller etternavnet
                    ForEach(persons.filter({ self.searchText.isEmpty ||
                        $0.firstName.localizedStandardContains(self.searchText) ||
                        $0.lastName.localizedStandardContains (self.searchText)    })) {
                            person in
                            NavigationLink(destination: PersonView(person: person)) {
                                VStack(alignment: .leading) {
                                    ShowPersons(person: person)
//                                    HStack(alignment: .center, spacing: 42.5) {
//                                        /// For å få vist iconene uten en space nedenfor dem, måtte jeg legge inn Text("  ")
//                                        Text("  ")
//                                        Image("map")
//                                            .resizable()
//                                            .frame(width: 46, height: 46, alignment: .center)
//                                        Image("phone")
//                                            .resizable()
//                                            .frame(width: 40, height: 40, alignment: .center)
//                                        Image("message")
//                                            .resizable()
//                                            .frame(width: 40, height: 40, alignment: .center)
//
//                                        Image("mail")
//                                            .resizable()
//                                            .frame(width: 46, height: 46, alignment: .center)
//                                    }
                                }
                            }
                    }
                        /// Sletter  valgt person og oppdaterer CliudKit
                        .onDelete { (indexSet) in
                            self.indexSetDelete = indexSet
                            self.recordID = self.persons[indexSet.first!].recordID
                            self.deletePersonActinSheet = true
                    }
                    .actionSheet(isPresented: $deletePersonActinSheet) {
                        ActionSheet(title: Text(NSLocalizedString("Delete person", comment: "PersonsOverView")),
                                    message: Text(NSLocalizedString("Are you sure you want to delete this person?", comment: "PersonsOverView")),
                                    buttons: [.default(Text(NSLocalizedString("No", comment: "PersonsOverView")), action: {

                                    }),
                                              .destructive(Text("Delete this person"), action: {
                                                CloudKitPerson.deletePerson(recordID: self.recordID!) { (result) in
                                                    switch result {
                                                    case .success :
                                                        self.message = NSLocalizedString("Successfully deleted a person", comment: "PersonsOverView")
                                                        self.alertIdentifier = AlertID(id: .first)
                                                    case .failure(let err):
                                                        self.message = err.localizedDescription
                                                        self.alertIdentifier = AlertID(id: .first)
                                                    }
                                                }
                                                /// Sletter den valgte raden
                                                self.persons.remove(atOffsets: self.indexSetDelete)
                                              }),
                                              .cancel()
                        ])
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle(personsOverview)
            .navigationBarItems(leading:
                Button(action: {
                    /// Rutine for å friske opp personoversikten
                    self.refresh()
                }, label: {
                    Text("Refresh")
                        .foregroundColor(.none)
                })
                , trailing:
                Button(action: {
                    /// Rutine for å legge til en person
                    self.newPerson.toggle()
                }, label: {
                    Text("Add")
                })
            )
        }
        .sheet(isPresented: $newPerson) {
            NewPersonView()
        }
        .onAppear {
            self.refresh()
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(self.message))
            case .third:
                return Alert(title: Text(self.message))
            }
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
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
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

//                $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending
//
//               // Must use local sorting of the poststedSectionTitles
//               let region = NSLocale.current.regionCode?.lowercased() // Returns the local region
//               let language = Locale(identifier: region!)
//                let sortedpoststedSection1 = self.persons.sorted {
//                    $0.compare($1, locale: language) == .orderedAscending
//     -----<           localizedCaseInsensitiveCompare(_:)
//
//               }

            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }
}

/// Et eget View for å vise person detail view
struct ShowPersons: View {

    @State private var showMap = false

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    var person: Person
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                if person.image != nil {
                    Image(uiImage: person.image!)
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .font(.system(size: 16, weight: .ultraLight))
                        .frame(width: 60, height: 60, alignment: .center)
                }
                VStack (alignment: .leading, spacing: 5) {
                    HStack {
                        /// Sletter første character i fornavnet dersom den er en emoji
                        TextDeleteFirstEmoji(firstName : person.firstName)
                            .font(Font.title.weight(.ultraLight))
                        Text(person.lastName)
                            .font(Font.body.weight(.ultraLight))
                    }
                    .font(Font.body.weight(.ultraLight))
                    Text("\(person.dateOfBirth, formatter: Self.taskDateFormat)")
                        .font(.custom("system", size: 17))
                    HStack {
                        Text(person.address)
                            .font(.custom("system", size: 17))
                    }
                    HStack {
                        Text(person.cityNumber)
                        Text(person.city)
                    }
                    .font(.custom("system", size: 17))
                }
            }
            HStack(alignment: .center, spacing: 42.5) {
                /// For å få vist iconene uten en space nedenfor dem, måtte jeg legge inn Text("  ")
                Text("  ")
                Image("map")
                    .resizable()
                    .frame(width: 46, height: 46, alignment: .center)
                Image("phone")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                Image("message")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)

                Image("mail")
                    .resizable()
                    .frame(width: 46, height: 46, alignment: .center)
            }

        }
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
    }
}

struct MapView: UIViewRepresentable {

    var locationOnMap: String
    var address: String
    var subtitle: String

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        /// Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationOnMap, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks {
                /// Get the first placemark
                let placemark = placemarks[0]
                /// placemark = Uelandsgata 2, Uelandsgata 2, 4360 Varhaug, Norge @ <+58.61729080,+5.64474960> +/- 100.00m, region CLCircularRegion (identifier:'<+58.61729080,+5.64474960> radius 70.82', center:<+58.61729080,+5.64474960>, radius:70.82m)
                /// Add annotation
                let annotation = MKPointAnnotation()
                mapView.addAnnotation(annotation)
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    annotation.title = self.address
                    annotation.subtitle = self.subtitle
                    /// Display the annotationn
                    mapView.showAnnotations([annotation], animated: true)
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }

        })
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }

}



func TextDeleteFirstEmoji(firstName : String) -> some View {
    let index0 = firstName.index(firstName.startIndex, offsetBy: 0)
    let index1 = firstName.index(firstName.startIndex, offsetBy: 1)

    let firstChar = String(firstName[index0...index0])

    if firstChar.containsEmoji  {
       return Text(firstName[index1...])
    }

    return Text(firstName)
}

/// The simplest, cleanest, and swiftiest way to accomplish this is to simply check the Unicode code points for each character in the string against known emoji and dingbats ranges, like so:
extension String {
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x2600...0x26FF,   // Misc symbols
                 0x2700...0x27BF,   // Dingbats
                 0xFE00...0xFE0F,   // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
}

