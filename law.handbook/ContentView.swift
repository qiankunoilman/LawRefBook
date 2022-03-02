//
//  ContentView.swift
//  law.handbook
//
//  Created by Hugh Liu on 24/2/2022.
//

import SwiftUI
import CoreData

struct LawSubList: View {

    var sub: LawGroup
    var body: some View {
        Section(header: Text(sub.name)) {
            ForEach(sub.laws, id: \.name) { law in
                NavigationLink(destination: LawContentView(model: law.getModal()).onAppear {
                    law.getModal().load()
                }){
                    Text(law.name)
                }
            }
        }
    }
}

struct LawList: View {

    var lawsArr: [LawGroup] = []
    var body: some View {
        List {
            ForEach(lawsArr, id: \.name) { sub in
                LawSubList(sub: sub)
            }
        }
    }
}

struct ContentView: View {

    @State var showSettingModal = false
    @State var showFavModal = false
    @State var searchText = ""

    var filteredLaws:  [LawGroup] {
        if searchText.isEmpty {
            return laws
        }
        return laws.filter {
            return !$0.laws.filter{$0.name.hasPrefix(searchText)}.isEmpty
        }
    }

    var body: some View {
        NavigationView{
            LawList(lawsArr: filteredLaws)
                .navigationBarTitle("中国法律")
                .toolbar {

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showFavModal.toggle()
                        }, label: {
                            Image(systemName: "heart")
                        }).foregroundColor(.red).sheet(isPresented: $showFavModal) {
                            NavigationView {
                                FavoriteView()
                                    .navigationBarTitle("收藏", displayMode: .inline)
                            }
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSettingModal.toggle()
                        }, label: {
                            Image(systemName: "gear")
                        }).foregroundColor(.red).sheet(isPresented: $showSettingModal) {
                            NavigationView {
                                SettingView()
                                    .navigationBarTitle("关于", displayMode: .inline)
                            }
                        }
                    }

                }
        }.searchable(text: $searchText, prompt: "宪法修正案")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }.previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
    }
}
