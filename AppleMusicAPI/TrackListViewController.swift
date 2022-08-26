//
//  TrackListViewController.swift
//  AppleMusicAPI
//
//  Created by Leysan Latypova on 23.08.2022.
//

import UIKit

class TrackListViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchResponse: SearchResponse? = nil
    private var timer: Timer?
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpSearchBar()
    }
    
    private func setUpSearchBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func setUpTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        print("track?.artworkUrl60", track?.artworkUrl60)
        cell.textLabel?.text = track?.trackName
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension TrackListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            NetworkDataFetcher.shared.fetchData(urlString: urlString) { searchResponse in
                guard let searchResponse = searchResponse else { return }
                self.searchResponse = searchResponse
                self.table.reloadData()
            }
        })
    }
}
