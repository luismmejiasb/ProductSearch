import Foundation

// MARK: - AlertDisplayable

/// Any router that can present an alert to the user.
@MainActor
protocol AlertDisplayable: AnyObject {
    func displayAlert(title: String, message: String)
}

// MARK: - PresenterErrorHandler

/// Centralised error-to-alert mapping. Eliminates duplicated displayError logic
/// across Presenters that depend on CloudDataSourceDefaultError.
enum PresenterErrorHandler {

    @MainActor
    static func handle(_ error: Error, with router: AlertDisplayable) {
        guard let cloudError = error as? CloudDataSourceDefaultError else { return }

        switch cloudError {
        case .httpError:
            router.displayAlert(
                title: "Error",
                message: "Tuvimos un error con nuestros servicios. Por favor, intenta nuevamente más tarde."
            )
        default:
            router.displayAlert(
                title: "Error en tu busqueda",
                message: "No pudimos continuar con tu búsqueda. Por favor, intenta nuevamente o con otra descripción del artista."
            )
        }
    }
}
