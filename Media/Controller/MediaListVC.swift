//
//  MediaListVC.swift
//  Media
//
//  Created by Apple on 06/01/2023.
//

import AVKit
import SQLite
import AVFoundation

class MediaListVC: UIViewController {
//MARK: - Outlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mediaTypeSegmenterControl: UISegmentedControl!
    @IBOutlet weak var mediaSearchBar: UISearchBar!
    
//MARK: - Properties.
    private var mediaArray = [Media]()
    private var mediaType: MediaType = .movie
    private var mediaSelection = MediaType.all.rawValue
    
    
//MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        tableView.dataSource = self
        tableView.delegate = self
        setNavigationView()
        tableView.register(UINib(nibName: "MediaCell", bundle: nil), forCellReuseIdentifier: "MediaCell")
    }
    
//MARK: - Actions.    
    @IBAction func changeSegmented(_ sender: UISegmentedControl) {
        changedSegment(sender)
    }
}
//MARK: - TableView
extension MediaListVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mediaArray.count == 0 {
            return 0
        }
        return mediaArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as? MediaCell
        else { return UITableViewCell() }
        cell.configrationCell(type: mediaType, media: mediaArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = mediaArray[indexPath.row].previewUrl {
            playMedia(mediaUrl: url)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
//MARK: - Search
extension MediaListVC : UISearchBarDelegate{
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
       func search() {
            mediaSearchBar.resignFirstResponder()
            if mediaSearchBar.text?.count ?? 0 >= 3{
                APIManager.getDataFromAPI(term: mediaSearchBar.text!, media: mediaType.rawValue) { error, mediarray in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        guard let mediarray = mediarray else {
                            return}
                        self.mediaArray = mediarray
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.showAlert(title: "Sorry", message: "Required search between 0...3 letters")
        }
    }
}
//MARK: - Private Methods
extension MediaListVC {
        private func setNavigationView () {
            self.navigationItem.title = "Media"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(goToProfileVC))
        }
        @objc private func goToProfileVC() {
            let ProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(ProfileVC, animated: true)
        }
        private func setSegment() {
            switch mediaSelection {
            case MediaType.tvShow.rawValue:
                mediaType = .tvShow
                mediaTypeSegmenterControl.selectedSegmentIndex = 1
            case MediaType.tvShow.rawValue:
                mediaType = .movie
                mediaTypeSegmenterControl.selectedSegmentIndex = 0
            case MediaType.tvShow.rawValue:
                mediaType = .music
                mediaTypeSegmenterControl.selectedSegmentIndex = 2
            default:
                mediaType = .all
                mediaTypeSegmenterControl.selectedSegmentIndex = 3
            }
        }
        private func changedSegment(_ sender: UISegmentedControl) {
            let number = sender.selectedSegmentIndex
            switch number {
            case 1:
                mediaType = .tvShow
            case 0:
                mediaType = .movie
            case 2:
                mediaType = .music
            default:
                mediaType =  .all
            }
            search()
        }
        private func playMedia(mediaUrl: String) {
            guard let url = URL(string: mediaUrl) else { return }
            let player = AVPlayer(url: url)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            present(playerVC, animated: true) {
                playerVC.player?.play()
        }
    }
}


