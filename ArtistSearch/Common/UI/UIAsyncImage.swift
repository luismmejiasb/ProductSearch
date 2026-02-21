import UIKit

extension UIImageView {
    @MainActor
    func setImage(
        from urlString: String,
        placeholder: UIImage? = nil
    ) async {
        image = placeholder

        guard let url = Self.buildSecureURL(from: urlString) else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let downloadedImage = UIImage(data: data) else {
                return
            }

            image = downloadedImage
        } catch {
            image = placeholder
        }
    }
}

// MARK: - Private helpers

private extension UIImageView {
    static func buildSecureURL(from urlString: String) -> URL? {
        let sanitizedString = urlString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
            .replacingOccurrences(of: "http:", with: "https:")

        guard let sanitizedString else {
            return nil
        }

        return URL(string: sanitizedString)
    }
}
