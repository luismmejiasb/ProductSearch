// MARK: - HomeCloudDataSource

import Alamofire
import Combine
import Foundation

final class HomeCloudDataSource: HomeCloudDataSourceProtocol {
    func searchArtist(searchText: String, limit: Int = 50) -> Future<ArtistSearchResult, Error> {
        Future { promise in
            AF.request(
                APIURL.searchArtist(searchText: searchText, limit: limit).url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default
            ).responseJSON { response in
                switch response.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        var searchResult = try JSONDecoder().decode(ArtistSearchResult.self, from: jsonData)
                        searchResult.searchText = searchText
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }

    func searchByMedia(mediaType: String, searchText: String, limit: Int = 50) -> Future<ArtistSearchResult, Error> {
        Future { promise in
            AF.request(
                APIURL.searchByMedia(mediaType: mediaType, searchText: searchText, limit: limit).url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default
            ).responseJSON { response in
                switch response.result {
                case .success(let response):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                        var searchResult = try JSONDecoder().decode(ArtistSearchResult.self, from: jsonData)
                        searchResult.searchText = searchText
                        return promise(.success(searchResult))
                    } catch {
                        return promise(.failure(CloudDataSourceDefaultError.responseCannotBeParsed))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
