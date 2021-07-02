//
//  DetailViewController.swift
//  swifty-companion
//
//  Created by Сергей on 02.07.2021.
//

import UIKit

class DetailViewController: UIViewController {

	private var user: String
	
	init(user: String) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = user
		self.view.backgroundColor = .link
    }

}
