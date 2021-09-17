//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Minh Nguyen on 15/09/2021.
//

import UIKit
import RxSwift
import RxMoya

class WeatherViewController: UIViewController {
    
    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var weatherForecast: WeatherForecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.useDynamicFont(forTextStyle: .headline)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        bindData()
    }
    
    func bindData() {
        viewModel.weatherForecast
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] weatherForecast in
            self?.weatherForecast = weatherForecast
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
            guard let error = error else { return }
            let alert = UIAlertController(title: "Oops", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    @objc
    func fetchWeatherData() {
        if let city = searchBar.text {
            viewModel.getWeatherForecastInfo(for: city)
        }
    }
}

// MARK: UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecast?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastCell") as! WeatherForecastCell
        cell.weatherItem = weatherForecast?.list?[indexPath.row]
        return cell
    }
}

// MARK: UISearchBarDelegate

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchWeatherData), object: nil)
        perform(#selector(self.fetchWeatherData), with: nil, afterDelay: 0.4)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
