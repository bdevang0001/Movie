import Foundation
import SwiftUI

class WatchListViewModel: ObservableObject {
    private var watchListStore: WatchListStore
    
    var movies: [MovieItem] {
        watchListStore.movies
    }
    
    init(watchListStore: WatchListStore) {
        self.watchListStore = watchListStore
    }
}
