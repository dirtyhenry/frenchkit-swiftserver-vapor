//
//  ListingViewController.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate
import EventAppCore

class ListingViewController: UITableViewController {

  /// Current controller state
  enum State {
    case empty
    case data(Results<Talk>)
    case error(Error)
  }

  // MARK: - Members

  private lazy var placeholderView: PlaceholderView = { return PlaceholderView.loadFromNib() }()
  private var state: State = .empty {
    didSet {
      updateState()
    }
  }

  private var talksToken: NotificationToken?

  // MARK: - Setup

  override func viewDidLoad() {
    super.viewDidLoad()
    title = L10n.listingTitle
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.leftBarButtonItem = editButtonItem

    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self,
                                    action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton

    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(reloadData), for: .allEvents)

    tableView.register(cellType: TalkCell.self)

    let talks = Realm.safeRealm.objects(Talk.self).sorted(byKeyPath: #keyPath(Talk.dateCreated),
                                                          ascending: false)
    state = talks.isEmpty ? .empty : .data(talks)
    talksToken = talks.observe { changes in

      switch changes {
      case .initial(let values):
        self.state = values.isEmpty ? .empty : .data(values)
        self.tableView.reloadData()

      case .update(let values, let deletions, let insertions, let modifications):
        self.state = values.isEmpty ? .empty : .data(values)

        guard self.tableView.isVisible else {
          self.tableView.reloadData()
          return
        }

        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: deletions.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.insertRows(at: insertions.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.reloadRows(at: modifications.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.endUpdates()

      case .error(let error):
        log.error("An error occured during update: \(error)")
        self.state = .error(error)
      }

    }
  }

  deinit {
    talksToken?.invalidate()
    talksToken = nil
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
    super.viewWillAppear(animated)
  }

  // MARK: - Actions

  @objc
  func insertNewObject(_ sender: Any) {

    let alert = UIAlertController(title: L10n.talkAddTitle,
                                  message: nil,
                                  preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = L10n.talkNamePlaceholder
    }
    alert.addAction(UIAlertAction(title: L10n.commonCancel, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: L10n.commonAdd, style: .default, handler: { _ in

      let name = alert.textFields?.first?.text ?? ""

      do {
        try Talk.add(name: name)
      } catch {
        self.state = .error(error)
      }

    }))

    self.present(alert, animated: true, completion: nil)
  }

  @objc
  private func reloadData() {

    if refreshControl?.isRefreshing == false {
      refreshControl?.beginRefreshing()
    }

    let talks = Realm.safeRealm.objects(Talk.self).sorted(byKeyPath: #keyPath(Talk.dateModified))
    state = talks.isEmpty ? .empty : .data(talks)

    refreshControl?.endRefreshing()
  }

  /// Update listing state
  private func updateState() {

    var plState: PlaceholderView.State?

    switch state {
    case .empty:
      plState = PlaceholderView.State(emotion: "🤐",
                                      title: L10n.listingEmptyTitle,
                                      details: L10n.listingEmptyDescription)
    case .data:
      break
    case .error(let error):
      plState = PlaceholderView.State(emotion: "😣",
                                      title: L10n.listingErrorTitle,
                                      details: error.localizedDescription)
    }

    if let plState = plState {
      placeholderView.state = plState
      placeholderView.frame = tableView.bounds
      tableView.tableHeaderView = placeholderView
      tableView.isScrollEnabled = false
    } else {
      tableView.tableHeaderView = nil
      tableView.isScrollEnabled = true
    }

  }

}

// MARK: - UITableViewDataSource
extension ListingViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard case .data(let talks) = state else { return 0 }

    return talks.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard case .data(let talks) = state else { fatalError("Cannot fill any cell without data") }

    let cell: TalkCell = tableView.dequeueReusableCell(for: indexPath)

    let talk = talks[indexPath.row]

    let currentFont: UIFont = cell.infoLabel.font ?? UIFont.preferredFont(forTextStyle: .body)
    let text = NSMutableAttributedString(
      string: talk.name ?? "",
      attributes: [.font: currentFont.withSize(currentFont.pointSize + 2)]
    )

    if let speaker = talk.speakerName, !speaker.isEmpty {

      text.append(NSAttributedString(
        string: "\n🎙 \(speaker)",
        attributes: [.foregroundColor: UIColor.blue,
                     .font: currentFont.withSize(currentFont.pointSize - 3)])
      )
    }

    if let dueDate = talk.dueDate {
      text.append(NSAttributedString(
        string: "\n📆 \(dueDate.toRelative())",
        attributes: [.foregroundColor: UIColor.gray,
                     .font: currentFont.withSize(currentFont.pointSize - 2)])
      )
    }

    if let notes = talk.notes, !notes.isEmpty {

      text.append(NSAttributedString(
        string: "\n📝 \(notes)",
        attributes: [.foregroundColor: UIColor.lightGray,
                     .font: currentFont.withSize(currentFont.pointSize - 3)])
      )
    }

    cell.infoLabel.attributedText = text

    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListingViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard case .data(let talks) = state else { return }

    let talk = talks[indexPath.row]

    let details = TalkDetailViewController.make(talk: talk)
    let navVC = UINavigationController(rootViewController: details)

    splitViewController?.showDetailViewController(navVC, sender: self)
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {

    guard case .data(let talks) = state else { return }

    if editingStyle == .delete {
      let talk = talks[indexPath.row]
      try? talk.delete()
    }
  }
}
