import Foundation

// MARK: - TransactionStatus

enum TransactionStatus {
    case success
    case failure
    case nilValue
}

// MARK: - CloudSourceMockError

enum CloudSourceMockError: LocalizedError {
    case nilValue
    case unknow
}

// MARK: - RepositoryMockError

enum RepositoryMockError: LocalizedError {
    case nilValue
    case unknow
}
