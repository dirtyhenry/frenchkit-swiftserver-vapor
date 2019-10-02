//
//  TalkCell.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import UIKit
import Reusable

final class TalkCell: UITableViewCell, NibReusable {

  @IBOutlet weak var infoLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    infoLabel.numberOfLines = 4
    selectionStyle = .gray
  }
}
