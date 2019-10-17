import Combine
import GRDB
import GRDBCombine
import Dispatch

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
                    for _ in 0..<8
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
    struct AllTheTests
    {
        //
        // Total number of players
        //
        var testCount: Int
        
        /// The best ones
        var bestTests: [Test]
    }
    
    //
    // A publisher that tracks changes in the Hall of Fame
    //
    func allTheTestsPublisher() -> DatabasePublishers.Value<AllTheTests>
    {
        ValueObservation
            .tracking(value:
            {
                db in
                    let testCount = try Test.fetchCount( db )
                    let bestTests = try Test.fetchAll( db )
                    return AllTheTests( testCount: testCount, bestTests: bestTests )
            })
            .publisher( in: database )
    }
    
    //
    // A publisher that tracks changes in the number of players
    //
    func playerCountPublisher() -> DatabasePublishers.Value<Int>
    {
        ValueObservation
            .tracking( value: Test.fetchCount )
            .publisher( in: database )
    }
}
