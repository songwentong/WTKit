//
//  ContentView.swift
//  WTModelMakerTool
//
//  Created by 宋文通 on 2020/3/18.
//  Copyright © 2020 宋文通. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            HStack {
                VStack{
                    Text("File Path")
                }.frame(width: 100, height: 40, alignment: .center)
                Text("Hello, World!")
                Text("Hello, World!")
            }
            HStack { Text("Placeholder\ndsadsas").frame(width: 300, height: 300, alignment: .center)
                Text("import Foundation").frame(width: 300, height: 300, alignment: .center)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
