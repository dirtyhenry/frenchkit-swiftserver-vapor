//
//  TextCell.swift
//  EventApp
//
//  Created by David Bonnet on 16/05/2018.
//  Copyright © 2018 harpp. All rights reserved.
//

import UIKit
import Reusable

final class TextCell: UITableViewCell, Reusable {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
