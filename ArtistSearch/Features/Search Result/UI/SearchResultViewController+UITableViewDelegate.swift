import Foundation
import UIKit

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let results = presenter?.getSearchResult()?.results,
            results.indices.contains(indexPath.row) else {
            return
        }
        let artist = results[indexPath.row]

        presenter?.presentArtistDetail(artist)
    }
}
