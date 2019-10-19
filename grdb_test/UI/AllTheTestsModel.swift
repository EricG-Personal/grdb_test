import Combine
import GRDBCombine
import SwiftUI

//
// A view controller that uses a @DatabasePublished property wrapper, and
// feeds both AllTheTestsViewController, and the SwiftUI AllTheTestsView.
//
class AllTheTestsModel
{
    //
    // @DatabasePublished automatically updates the allTheTests
    // property whenever the database changes.
    //
    // The property is a Result because database access may
    // eventually fail.
    //
    @DatabasePublished( Current.tests().allTheTestsPublisher() )
    private var allTheTests: Result<Tests.AllTheTests, Error>
    
    @DatabasePublished( Current.tests().allTheUniqueTestsPublisher() )
    private var allTheUniqueTests: Result<[Test], Error>
    
    // MARK: - Publishers
    
    /// A publisher for the best players
    var bestTestsPublisher: AnyPublisher<[Test], Never>
    {
        $allTheTests
            .map { $0.bestTests }
            .replaceError(with: Self.errorBestTests)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Current Values
    
    /// The best players
    var bestTests: [Test]
    {
        do
        {
            return try allTheTests.get().bestTests
        }
        catch
        {
            return Self.errorBestTests
        }
    }
    
    var uniqueTests: [Test]
    {
        do
        {
            return try allTheUniqueTests.get()
        }
        catch
        {
            return Self.errorBestTests
        }
    }
    
    // MARK: - Helpers
    
    private static let errorTitle = "An error occured"
    private static let errorBestTests: [Test] = []
}

// MARK: - SwiftUI Support

extension AllTheTestsModel: ObservableObject
{
    var objectWillChange: PassthroughSubject<Void, Never>
    {
        return $allTheTests.objectWillChange
    }
}

