//
//  ApplicationViewController.swift
//  Applications
//
//  Created by Ignacio Romero Zurbuchen on 2020-01-02.
//  Copyright © 2020 DZN. All rights reserved.
//

import UIKit
import EmptyDataSet

class ApplicationViewController: UITableViewController {

    var app: Application?

    @objc
    convenience init(application: Application) {
        self.init(nibName: nil, bundle: nil)
        app = application
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        view.backgroundColor = .white

        configureHeaderAndFooter()
        configureNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.setNeedsStatusBarAppearanceUpdate()
    }

    func configureHeaderAndFooter() {
        guard let app = app else { return }

        var imageName: String?

        if app.type == .typePinterest {
            imageName = "header_pinterest"
        } else if app.type == .typePodcasts {
            imageName = "header_podcasts"
        }

        if let imageName = imageName, let image = UIImage(named: imageName) {
            let imageView = UIImageView(image: image)

            let frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: image.size.height))
            let headerView = UIView(frame: frame)
            imageView.center = headerView.center
            headerView.addSubview(imageView)

            tableView.tableHeaderView = headerView
        }

        tableView.tableFooterView = UIView()
    }

    func configureNavigationBar() {
        guard let app = app else { return }

        if let logoImage = UIImage(named: "logo_\(app.displayName.lowercased())") {
            navigationItem.titleView = UIImageView(image: logoImage)
        } else {
            navigationItem.titleView = nil
            navigationItem.title = app.displayName
        }

        let barColor = UIColor(hex: app.barColor)
        let tintColor = UIColor(hex: app.tintColor)

        navigationController?.navigationBar.titleTextAttributes = nil
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.tintColor = tintColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let app = app else { return .default }

        switch (app.type) {
            case .type500px,
                 .typeCamera,
                 .typeFacebook,
                 .typeFancy,
                 .typeFoursquare,
                 .typeInstagram,
                 .typePath,
                 .typeSkype,
                 .typeTumblr,
                 .typeTwitter,
                 .typeVesper,
                 .typeVine:
                return .lightContent
            default:
                return .default
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ApplicationViewController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard let app = app, let title = app.title else { return nil }

        var attributes = [NSAttributedString.Key: Any]()

        switch app.type {
        case .type500px:
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 17, weight: .bold)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor(hex: "545454")
        case .typeAirbnb:
            attributes[NSAttributedString.Key.font] = UIFont(name: "HelveticaNeue-Light", size: 22)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor(hex: "c9c9c9")
        default:
            break
        }

        return NSAttributedString(string: title, attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        guard let app = app, let subtitle = app.subtitle  else { return nil }

        var attributes = [NSAttributedString.Key: Any]()

        switch app.type {
        case .type500px:
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 15, weight: .bold)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor(hex: "545454")
        case .typeAirbnb:
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 13, weight: .regular)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor(hex: "cfcfcf")
        default:
            break
        }

        return NSAttributedString(string: subtitle, attributes: attributes)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        guard let app = app else { return nil }

        let imageName = "placeholder_\(app.displayName.lowercased())".replacingOccurrences(of: " ", with: "_")
        return UIImage(named: imageName)
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        guard let app = app else { return nil }
        return UIColor(hex: app.backgroundColor)
    }
}

extension ApplicationViewController: EmptyDataSetDelegate {

}


//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = nil;
//    UIFont *font = nil;
//    UIColor *textColor = nil;
//
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//
//    switch (self.application.type) {

//        case ApplicationTypeCamera:
//        {
//            text = @"Please Allow Photo Access";
//            font = [UIFont boldSystemFontOfSize:18.0];
//            textColor = [UIColor colorWithHex:@"5f6978"];
//            break;
//        }
//        case ApplicationTypeDropbox:
//        {
//            text = @"Star Your Favorite Files";
//            font = [UIFont boldSystemFontOfSize:17.0];
//            textColor = [UIColor colorWithHex:@"25282b"];
//            break;
//        }
//        case ApplicationTypeFacebook:
//        {
//            text = @"No friends to show.";
//            font = [UIFont boldSystemFontOfSize:22.0];
//            textColor = [UIColor colorWithHex:@"acafbd"];
//
//            NSShadow *shadow = [NSShadow new];
//            shadow.shadowColor = [UIColor whiteColor];
//            shadow.shadowOffset = CGSizeMake(0.0, 1.0);
//            [attributes setObject:shadow forKey:NSShadowAttributeName];
//            break;
//        }
//        case ApplicationTypeFancy:
//        {
//            text = @"No Owns yet";
//            font = [UIFont boldSystemFontOfSize:14.0];
//            textColor = [UIColor colorWithHex:@"494c53"];
//            break;
//        }
//        case ApplicationTypeiCloud:
//        {
//            text = @"iCloud Photo Sharing";
//            break;
//        }
//        case ApplicationTypeInstagram:
//        {
//            text = @"Instagram Direct";
//            font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0];
//            textColor = [UIColor colorWithHex:@"444444"];
//            break;
//        }
//        case ApplicationTypeiTunesConnect:
//        {
//            text = @"No Favorites";
//            font = [UIFont systemFontOfSize:22.0];
//            break;
//        }
//        case ApplicationTypeKickstarter:
//        {
//            text = @"Activity empty";
//            font = [UIFont boldSystemFontOfSize:16.0];
//            textColor = [UIColor colorWithHex:@"828587"];
//            [attributes setObject:@(-0.10) forKey:NSKernAttributeName];
//            break;
//        }
//        case ApplicationTypePath:
//        {
//            text = @"Message Your Friends";
//            font = [UIFont boldSystemFontOfSize:14.0];
//            textColor = [UIColor whiteColor];
//            break;
//        }
//        case ApplicationTypePinterest:
//        {
//            text = @"No boards to display";
//            font = [UIFont boldSystemFontOfSize:18.0];
//            textColor = [UIColor colorWithHex:@"666666"];
//            break;
//        }
//        case ApplicationTypePhotos:
//        {
//            text = @"No Photos or Videos";
//            break;
//        }
//        case ApplicationTypePodcasts:
//        {
//            text = @"No Podcasts";
//            break;
//        }
//        case ApplicationTypeRemote:
//        {
//            text = @"Cannot Connect to a Local Network";
//            font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
//            textColor = [UIColor colorWithHex:@"555555"];
//            break;
//        }
//        case ApplicationTypeTumblr:
//        {
//            text = @"This is your Dashboard.";
//            font = [UIFont boldSystemFontOfSize:18.0];
//            textColor = [UIColor colorWithHex:@"aab6c4"];
//            break;
//        }
//        case ApplicationTypeTwitter:
//        {
//            text = @"No lists";
//            font = [UIFont boldSystemFontOfSize:14.0];
//            textColor = [UIColor colorWithHex:@"292f33"];
//            break;
//        }
//        case ApplicationTypeVesper:
//        {
//            text = @"No Notes";
//            font = [UIFont fontWithName:@"IdealSans-Book-Pro" size:16.0];
//            textColor = [UIColor colorWithHex:@"d9dce1"];
//            break;
//        }
//        case ApplicationTypeVideos:
//        {
//            text = @"AirPlay";
//            font = [UIFont systemFontOfSize:17.0];
//            textColor = [UIColor colorWithHex:@"414141"];
//            break;
//        }
//        case ApplicationTypeVine:
//        {
//            text = @"Welcome to VMs";
//            font = [UIFont boldSystemFontOfSize:22.0];
//            textColor = [UIColor colorWithHex:@"595959"];
//            [attributes setObject:@(0.45) forKey:NSKernAttributeName];
//            break;
//        }
//        case ApplicationTypeWhatsapp:
//        {
//            text = @"No Media";
//            font = [UIFont systemFontOfSize:20.0];
//            textColor = [UIColor colorWithHex:@"808080"];
//            break;
//        }
//        case ApplicationTypeWWDC:
//        {
//            text = @"No Favorites";
//            font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
//            textColor = [UIColor colorWithHex:@"b9b9b9"];
//            break;
//        }
//        default:
//            return nil;
//    }
//
//    if (!text) {
//        return nil;
//    }
//
//    if (font) [attributes setObject:font forKey:NSFontAttributeName];
//    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
