import Foundation

enum CloudDataSourceDefaultError: Error {
    case unwrappableValue
    case responseCannotBeParsed
    case httpError(code: Int, message: String)
}
