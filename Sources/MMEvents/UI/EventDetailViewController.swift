//
//  EventDetailViewController.swift
//  
//
//  Created by Lennart Fischer on 14.06.21.
//

#if canImport(UIKit)
import UIKit
import Gestalt
import MapKit
import MMAPI

#if !os(tvOS)
import SafariServices
#endif

open class EventDetailViewController: UIViewController {
    
    public let viewModel: EventDetailsViewModel
    private let eventDetailView: EventDetailView
    
    public init(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        self.eventDetailView = EventDetailView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController Lifecycle
    
    override open func loadView() {
        view = eventDetailView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
//        self.title = String.localized("Details")
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.eventDetailView.navigationAction = navigationAction
        self.eventDetailView.websiteAction = websiteAction
        self.eventDetailView.reminderAction = reminderAction
        
        if let eventID = viewModel.model?.id {
            
            let isLiked = EventManager.shared.isLiked(id: eventID)
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: isLiked ? Images.heartFill : Images.heartOutline,
                style: .plain,
                target: self,
                action: #selector(toggleHeart(barButtonItem:))
            )
            
        }
        
    }
    
    // MARK: - UI Actions
    
    private func navigationAction() {
        
        let _ = viewModel.model
        
        // TODO: 
        
//        if let event = event {
//
//            let viewModel = EventViewModel(event: event)
//
//            viewModel.locationRepresentation
//
//            let preview = LocationPreviewModel(
//                name: event.getLocation()?.name ?? event.extras?.location ?? "",
//                coordinate: event.getLocation()?.coordinate ?? event.extras?.coordinate,
//                street: event.getLocation()?.street ?? event.extras?.street,
//                houseNumber: event.getLocation()?.houseNumber ?? event.extras?.houseNumber,
//                postcode: event.getLocation()?.postcode ?? event.extras?.postcode,
//                place: event.getLocation()?.place ?? event.extras?.place
//            )
//
//            let locationPreviewViewModel = LocationPreviewViewModel(model: preview)
//            let locationPreviewViewController = LocationPreviewViewController(viewModel: locationPreviewViewModel)
//
//            self.navigationController?.pushViewController(locationPreviewViewController, animated: true)
//
//        }
        
    }
    
    private func websiteAction() {
        
        #if !os(tvOS)
        if let url = viewModel.webURL {
            
            let svc = SFSafariViewController(url: url)
            svc.preferredBarTintColor = navigationController?.navigationBar.barTintColor
            svc.preferredControlTintColor = navigationController?.navigationBar.tintColor
            self.present(svc, animated: true, completion: nil)
            
        }
        #endif
        
    }
    
    private func reminderAction() {
        
    }
    
    @objc private func toggleHeart(barButtonItem: UIBarButtonItem) {
        
        // TODO: Improve this
        // https://www.swiftbysundell.com/posts/different-flavors-of-view-models-in-swift
        
        let eventID = viewModel.model?.id
        
        if let eventID = eventID {
            
            let isLiked = EventManager.shared.toggleLike(for: eventID)
            
            if isLiked {
                barButtonItem.image = Images.heartFill
            } else {
                barButtonItem.image = Images.heartOutline
            }
            
        }
        
    }
    
}

#endif
