//
//  ContentView.swift
//  Bucketlist
//
//  Created by Kenji Dela Cruz on 8/9/24.
//

//import SwiftUI
//struct User: Comparable,Identifiable {
//    let id = UUID()
//    var firstName: String
//    var lastName: String
//    
//    static func <(lhs: User, rhs: User) -> Bool {
//        return lhs.lastName < rhs.lastName
//    }
//}
//
//struct ContentView: View {
//    let users  = [
//        User(firstName: "Arnold", lastName: "Rimmer"),
//        User(firstName: "Kristine", lastName: "Kochanski"),
//        User(firstName: "David", lastName: "Lister")
//    ].sorted()
//    let values = [1, 5, 3, 6, 2, 9].sorted()
//    var body: some View {
//        List(users) { user in
//            Text("\(user.lastName), \(user.firstName)")
//        }
//    }
//}
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        Button("Read and Write") {
//            let data = Data("Test Message".utf8)
//            let url = URL.documentsDirectory.appending(path: "message.txt")
//            
//            do {
//                try data.write(to: url, options: [.atomic, .completeFileProtection])
//                let input = try String(contentsOf: url)
//                print(input)
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//}

import SwiftUI
import MapKit
import LocalAuthentication


struct ContentView: View {
    
    @State private var viewModel = ViewModel()

    var body: some View {
        if viewModel.isUnlocked {
            VStack{
                MapReader { proxy in
                    Map(initialPosition: viewModel.startPosition)
                    {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.inStandardMode ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place){
                            viewModel.updateLocation(location: $0)
                        }
                    }
                }
                HStack{
                    Toggle("Standard", isOn: $viewModel.inStandardMode)
                }
                .padding(15)
                
            }
        } else {
            Button{viewModel.authenticate()} label: {
                Image(systemName: "faceid")
                    .resizable()
                    .frame(width: 140,height: 140)
            }
            .alert("Authentication Failed" , isPresented: $viewModel.authError) {
                Button("ok", role: .none) { }
            } message: {
                Text(viewModel.authErrorMessage)
            }
        }
    }
}
#Preview {
    ContentView()
}
