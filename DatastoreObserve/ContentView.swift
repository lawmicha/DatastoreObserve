//
//  ContentView.swift
//  DatastoreObserve
//
//  Created by Law, Michael on 2/19/21.
//

import SwiftUI
import Amplify
import Combine

class ContentViewModel: ObservableObject {
    let listener: UnsubscribeToken
    var sink: AnyCancellable?
    init() {
        let dataStoreReady = HubFilters.forEventName(HubPayload.EventName.DataStore.ready)
        listener = Amplify.Hub.listen(to: .dataStore, isIncluded: dataStoreReady, listener: { (payload) in
            print("LAWMICHA: Got ready event: \(payload)")
        })
    }
    
    func setUpObserver() {
        sink = Amplify.DataStore.publisher(for: TestModel.self).sink {
            if case let .failure(error) = $0 {
                print("LAWMICHA: Subscription received error \(error)")
            }
        } receiveValue: { (changes) in
            print("LAWMICHA: Subscription received mutation \(changes)")
        }
    }
}
struct ContentView: View {
    @ObservedObject var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            Button("Save", action: {
                let model = TestModel(testInt: 1, testFloat: 1.0, testString: "test", testBool: true, testEnum: .valueOne)
                Amplify.DataStore.save(model) { (result) in
                    switch result {
                    case .success(let model):
                        print("LAWMICHA: Saved \(model)")
                    case .failure(let error):
                        print("LAWMICHA: Failed to save \(error)")
                    }
                }
            })
            Button("Query", action: {
                Amplify.DataStore.query(TestModel.self) { (result) in
                    switch result {
                    case .success(let testModels):
                        print("LAWMICHA: Got list of test models: \(testModels)")
                    case .failure(let error):
                        print("LAWMICHA: Failed to query list: \(error)")
                    }
                }
            })
            Button("DataStore.clear", action: {
                Amplify.DataStore.clear { (result) in
                    switch result {
                    case .success:
                        print("LAWMICHA: DataStore.clear completed")
                    case .failure(let error):
                        print("LAWMICHA: Error \(error)")
                    }
                }
            })
            Button("Set up observer", action: {
                vm.setUpObserver()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
