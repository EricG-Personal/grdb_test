//
//  ContentView.swift
//  grdb_test
//
//  Created by ericg on 10/16/19.
//  Copyright © 2019 ericg. All rights reserved.
//

import SwiftUI

struct ContentView: View
{
    @ObservedObject var viewModel: AllTheTestsModel
    
    var body: some View
    {
        VStack
        {
            Text( "All Items" )
            
            List( viewModel.bestTests )
            {
                TestRow( test: $0 )
            }
            
            Text( "Unique Items" )

            List( viewModel.uniqueTests )
            {
                Text( $0.name )
            }
        }
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
