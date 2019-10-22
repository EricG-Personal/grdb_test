import Combine
import GRDB
import GRDBCombine
import Dispatch
import os


//
// Players is responsible for high-level operations on the players database.
//
struct Tests
{
    private let database: DatabaseWriter
    
    init( database: DatabaseWriter )
    {
        self.database = database
    }
    
    // MARK: - Modify Players
    
    func deleteAll() throws
    {
        try database.write { db in
            _ = try Test.deleteAll( db )
        }
    }
    
    func refresh() throws
    {
        try database.write
        {
            db in
                if try Test.fetchCount( db ) == 0
                {
                    // Insert new random players
                    for _ in 0..<5
                    {
                        var test = Test(id: nil, name: Test.randomName() )
                        try test.insert( db )
                    }
                }
                else
                {
                    //
                    // Insert a player
                    //
                    if Bool.random()
                    {
                        var test = Test( id: nil, name: Test.randomName() )
                        try test.insert( db )
                    }
                    
                    //
                    // Delete a random player
                    //
                    if Bool.random()
                    {
                        try Test.order( sql: "RANDOM()" ).limit( 1 ).deleteAll( db )
                    }
                }
        }
    }
    
    
    
    func insert_name( name: String ) throws
    {
        try database.write
        {
            db in
                var test = Test(id: nil, name: name )
                try test.insert( db )
        }
    }
    
    
    
    func stressTest()
    {
        for _ in 0..<50
        {
            DispatchQueue.global().async
            {
                try? self.refresh()
            }
        }
    }
    
    // MARK: - Access Players
    
    //
    // A Hole of Fame
    //
    
    //
    // A publisher that tracks changes in the Hall of Fame
    //
    func allTheTestsPublisher() -> DatabasePublishers.Value<[Test]>
    {
        ValueObservation
            .tracking(value:
            {
                db in
                    let bestTests = try Test.fetchAll( db )
                    return bestTests
            })
            .publisher( in: database )
    }
    
    
    func allTheUniqueTestsPublisher() -> DatabasePublishers.Value<[Test]>
    {
        ValueObservation
            .tracking(value:
            {
                db in
                    let bestTests = try Test.fetchAll( db )
                    return bestTests
            })
            .map { (theTests: [Test]) -> [Test] in
                
                var uniqueTests: [Test] = []

                for aTest in theTests
                {
                    var found = false
                    
                    for uniqueTest in uniqueTests
                    {
                        if uniqueTest.name == aTest.name
                        {
                            found = true
                            break
                        }
                    }
                    
                    if found == false
                    {
                        uniqueTests.append( aTest )
                    }
                }
                
                return uniqueTests                                
            }
            .publisher( in: database )
    }
}
