import GRDB

//
// A plain Player struct
//
struct Test
{
    //
    // Use Int64 for auto-incremented database ids
    //
    var id:     Int64?
    var name:   String
}

//
// MARK: - Persistence
//
// Turn Player into a Codable Record.
// See https://github.com/groue/GRDB.swift/blob/master/README.md#records
//
extension Test: Codable, FetchableRecord, MutablePersistableRecord
{
    //
    // Define database columns from CodingKeys
    //
    fileprivate enum Columns
    {
        static let id   = Column( CodingKeys.id )
        static let name = Column( CodingKeys.name )
    }
    
    //
    // Update a player id after it has been inserted in the database.
    //
    mutating func didInsert( with rowID: Int64, for column: String? )
    {
        id = rowID
    }
}

//
// MARK: - Database access
//
// Define some useful player requests.
// See https://github.com/groue/GRDB.swift/blob/master/README.md#requests
//
extension DerivableRequest where RowDecoder == Test
{
    func orderedByName() -> Self
    {
        order(Test.Columns.name)
    }
}

// MARK: - Player Randomization

extension Test
{
    private static let names = [ "Arthur", "Anita", "Barbara", "Bernard", "Chiara", "David" ]
    
    static func randomName() -> String
    {
        names.randomElement()!
    }
}

