import GRDB

//
// A type responsible for initializing the application database.
//
// See AppDelegate.setupDatabase()
//
struct AppDatabase
{
    //
    // Creates a fully initialized database at path
    //
    static func openDatabase( atPath path: String ) throws -> DatabasePool
    {
        //
        // Connect to the database
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
        //
        let dbPool = try DatabasePool( path: path )
        
        //
        // Define the database schema
        //
        try migrator.migrate( dbPool )
        
        return dbPool
    }
    
    //
    // The DatabaseMigrator that defines the database schema.
    //
    // See https://github.com/groue/GRDB.swift/blob/master/README.md#migrations
    //
    static var migrator: DatabaseMigrator
    {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration( "createTest" )
        {
            db in
                //
                // Create a table
                // See https://github.com/groue/GRDB.swift#create-tables
                //
                try db.create( table: "test" )
                {
                    t in
                        t.autoIncrementedPrimaryKey( "id" )
                        
                        //
                        // Sort player names in a localized case insensitive fashion by default
                        // See https://github.com/groue/GRDB.swift/blob/master/README.md#unicode
                        //
                        t.column("name", .text).notNull()
                }
        }
        
        migrator.registerMigration("fixtures") { db in
            // Populate the players table with random data
            for _ in 0..<5
            {
                var test = Test( id: nil, name: Test.randomName() )
                try test.insert( db )
            }
        }
        
        return migrator
    }
}

