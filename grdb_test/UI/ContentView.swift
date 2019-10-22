//
//  ContentView.swift
//  grdb_test
//
//  Created by ericg on 10/16/19.
//  Copyright © 2019 ericg. All rights reserved.
//

import SwiftUI
import os

struct ContentView: View
{
    @ObservedObject var viewModel: AllTheTestsModel
    
    @State private var name: String = ""
    
    var body: some View
    {
        VStack
        {
            TextField( "new name", text: $name )

            Button( action: {
                os_log( "%@", self.name )
                try! Current.tests().insert_name( name: self.name )
            } ) {
                Text( "Add Name" )
            }
            
            Text( "All Items" ).padding( .top )
            
            List( viewModel.bestTests )
            {
                TestRow( test: $0 )
            }
            
            Text( "Unique Items" )

            List( viewModel.uniqueTests )
            {
                Text( $0.name )
            }
        }.padding()
    }
}


struct TestRow: View
{
    var test: Test
    
    var body: some View
    {
        Text( test.name )
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView( viewModel: AllTheTestsModel() )
//    }
//}
