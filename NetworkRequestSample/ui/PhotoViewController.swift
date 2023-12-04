//
//  PhotoViewController.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import UIKit
import Combine

class PhotoViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewModel: PhotoViewModel
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseableIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    enum Section: String {
        case main
    }

    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Photo list", comment: "")
        
        setupCollectionView()
        configureDataSource()
        
        viewModel.$photos
            .sink(receiveValue: { [weak self] photos in
            self?.applySnapshot(photos)
        })
        .store(in: &cancellables)
        
        viewModel.$error
            .sink { [weak self]  error in
            guard let error = error else { return }
            self?.showErrorAlert(message: error.localizedDescription)
        }
        .store(in: &cancellables)
        
        viewModel.loadPhotos()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseableIdentifier, for: indexPath) as? PhotoCell else {
                fatalError("could not find PhotoCell")
            }
            cell.configure(with: item)
            return cell
        })
    }
    
    private func applySnapshot(_ items: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
    }
}
