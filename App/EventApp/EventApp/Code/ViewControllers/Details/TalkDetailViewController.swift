//
//  TalkDetailViewController.swift
//  EventApp
//
//  Copyright © 2018 harpp. All rights reserved.
//

import UIKit
import EventAppCore
import RealmSwift
import SwiftDate

final class TalkDetailViewController: UITableViewController {

  // MARK: - Structure

  private struct Section {
    var title: String?
    var rows: [Row]
  }

  private enum Row {
    case text(title: String?, details: String?)
    case editable(text: String?, placeholder: String?)
    case `switch`(text: String, isOn: Bool)
    case date(title: String, date: Date)
    case datePicker(date: Date)
    case notes(text: String?)
    case delete
  }

  // MARK: - Members

  private lazy var photoImageView: UIImageView = {
    return UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
  }()

  var talk: Talk? {
    didSet {
      title = talk?.name

      if let talk = talk, let uuid = UUID(uuidString: talk.identifier) {
        self.updater = TalksUpdater(id: uuid)
      }

      if isViewLoaded {
        configureView()
      }
    }
  }

  private var sections: [Section] = []
  private var updater: TalksUpdater?

  // MARK: - Setup

  static func make(talk: Talk) -> TalkDetailViewController {
    let detailsVC = StoryboardScene.Listing.talkDetailViewController.instantiate()
    detailsVC.talk = talk

    return detailsVC
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

    tableView.register(cellType: TextCell.self)
    tableView.register(cellType: EditableCell.self)
    tableView.register(cellType: DatePickerCell.self)
    tableView.register(cellType: NotesCell.self)

    if let talk = talk, let uuid = UUID(uuidString: talk.identifier) {
      self.updater = TalksUpdater(id: uuid)
    }

    configureView()
  }

  private func configureView() {

    guard let talk = talk else {
      return
    }

    var sections = [Section]()

    //name
    sections.append(Section(title: L10n.talkNameTitle,
                            rows: [.editable(text: talk.name, placeholder: L10n.talkNamePlaceholder)]))

    //speaker
    sections.append(Section(title: L10n.talkSpeakerNameTitle,
                            rows: [.editable(text: talk.speakerName,
                                             placeholder: L10n.talkSpeakerNamePlaceholder)]))

    //date
    var dateSection = Section(title: L10n.talkDateTitle,
                              rows:
      [
        .switch(text: L10n.talkDateAsk, isOn: talk.dueDate != nil)
      ])

    if let dueDate = talk.dueDate {
      dateSection.rows.append(Row.date(title: L10n.talkDateAlarm, date: dueDate))
    }

    sections.append(dateSection)

    //notes
    sections.append(Section(title: L10n.talkNotesTitle, rows: [.notes(text: talk.notes)] ))

    //delete
    sections.append(Section(title: nil, rows: [.delete] ))

    self.sections = sections
    self.tableView.reloadData()
  }

  // MARK: - Actions

  @objc
  private func editingChanged(_ sender: UITextField) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    let section = sections[idx.section]
    let row = section.rows[idx.row]
    guard case .editable = row else { return }

    let realm = Realm.safeRealm
    try? realm.write {
      if section.title == L10n.talkNameTitle {
        talk?.name = sender.text
      } else {
        talk?.speakerName = sender.text
      }
    }
  }

  @objc
  private func didEndEditing(_ sender: UITextField) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    let section = sections[idx.section]
    let row = section.rows[idx.row]
    guard case .editable = row else { return }

    if section.title == L10n.talkNameTitle {
      title = sender.text
    }

    sendUpdate()
  }

  @objc
  private func toggleSwitch(_ sender: UISwitch) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    var section = sections[idx.section]

    if sender.isOn {
      section.rows.append(Row.date(title: L10n.talkDateAlarm, date: talk?.dueDate ?? Date() ))
    } else {
      section.rows.removeLast(section.rows.count - 1)

      let realm = Realm.safeRealm
      try? realm.write {
        talk?.dueDate = nil
        sendUpdate()
      }
    }

    if let row = section.rows.first, case .switch(let text, _) = row {
      section.rows[0] = .switch(text: text, isOn: sender.isOn)
    }
    sections[idx.section] = section

    tableView.reloadSections(IndexSet(integer: idx.section), with: .automatic)
  }

  private func toggleDatePicker(onSection sectionIdx: Int) {

    guard sectionIdx < sections.count else { return }

    tableView.beginUpdates()

    var section = sections[sectionIdx]
    if let row = section.rows.last, case .datePicker = row {
      tableView.deleteRows(at: [IndexPath(row: section.rows.count - 1, section: sectionIdx)],
                           with: .automatic)
      section.rows.removeLast()
    } else {
      section.rows.append(Row.datePicker(date: talk?.dueDate ?? Date()))
      tableView.insertRows(at: [IndexPath(row: section.rows.count - 1, section: sectionIdx)],
                           with: .automatic)
    }

    sections[sectionIdx] = section
    tableView.endUpdates()
  }

  @objc
  private func datePickerChanged(_ sender: UIDatePicker) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    var section = sections[idx.section]
    section.rows[1] = Row.date(title: L10n.talkDateAlarm, date: sender.date)
    sections[idx.section] = section
    tableView.reloadRows(at: [IndexPath(row: 1, section: idx.section)], with: .none)

    let realm = Realm.safeRealm
    try? realm.write {
      talk?.dueDate = sender.date

      sendUpdate()
    }

  }

  func sendUpdate() {
    guard let talk = talk else { return }

    updater?.update(talk: talk)
  }
}

// MARK: - UITableViewDataSource
extension TalkDetailViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .text(let title, let details):
      return textCell(in: tableView, at: indexPath, text: title, details: details)

    case .editable(let text, let placeholder):
      let cell: EditableCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textfield.placeholder = placeholder
      cell.textfield.text = text
      cell.textfield.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
      cell.textfield.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
      return cell

    case .switch(let text, let isOn):
      let `switch` = UISwitch(frame: .zero)
      `switch`.isOn = isOn
      `switch`.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)

      return textCell(in: tableView, at: indexPath, text: text, details: nil, accessoryView: `switch`)

    case .date(let title, let date):
      let details = date.toString(.dateTime(.short))

      return textCell(in: tableView, at: indexPath, text: title, details: details)

    case .datePicker(let date):
      let cell: DatePickerCell = tableView.dequeueReusableCell(for: indexPath)
      cell.datePicker.date = date
      cell.datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
      return cell

    case .notes(let text):
      let cell: NotesCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textview.text = text
      cell.textview.delegate = self
      return cell

    case .delete:
      let cell = textCell(in: tableView, at: indexPath, text: L10n.talkDelete, details: nil)
      cell.textLabel?.textColor = UIColor.red
      return cell
    }

  }

  private func textCell(in tableView: UITableView,
                        at indexPath: IndexPath,
                        text: String?,
                        details: String?,
                        accessoryView: UIView? = nil) -> TextCell {

    let cell: TextCell = tableView.dequeueReusableCell(for: indexPath)
    cell.textLabel?.text = text
    cell.textLabel?.textColor = UIColor.black
    cell.detailTextLabel?.text = details
    cell.accessoryView = accessoryView
    return cell
  }

}

// MARK: - UITableViewDelegate
extension TalkDetailViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .date:
      toggleDatePicker(onSection: indexPath.section)
    case .delete:
      try? talk?.delete()
      updater?.delete()
      navigationController?.navigationController?.popViewController(animated: true)
    default:
      break
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .datePicker:
      return 200
    default:
      return 50
    }

  }
}

extension TalkDetailViewController: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    let realm = Realm.safeRealm
    try? realm.write {
      talk?.notes = textView.text

      sendUpdate()
    }

  }
}
