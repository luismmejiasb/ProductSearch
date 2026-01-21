import Foundation
import UIKit

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter?.getSearchResult()?.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: SearchResultUITableViewCell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultUITableViewCell.reusableIdentifier,
                for: indexPath
            ) as? SearchResultUITableViewCell,
            let result: Result = presenter?.getSearchResult()?.results?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cell.layoutIfNeeded()
        cell.configureCell(with: result)
        return cell
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.getSearchResult()?.results?.count {
            UILoadingIndicator.startLoadingIndicatorIn(view ?? UIView(), position: .bottom)
            presenter?.fetchNextOffSet()
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        94
    }
}
