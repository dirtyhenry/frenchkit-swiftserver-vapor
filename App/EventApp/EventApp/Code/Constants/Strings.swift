// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// EventApp
  internal static let appname = L10n.tr("Localizable", "appname")
  /// Add
  internal static let commonAdd = L10n.tr("Localizable", "common.add")
  /// Cancel
  internal static let commonCancel = L10n.tr("Localizable", "common.cancel")
  /// Ok
  internal static let commonOk = L10n.tr("Localizable", "common.ok")
  /// Talks
  internal static let listingTitle = L10n.tr("Localizable", "listing.title")
  /// Are you sure you're gonna sell tickets?
  internal static let listingEmptyDescription = L10n.tr("Localizable", "listing.empty.description")
  /// No talk yet!
  internal static let listingEmptyTitle = L10n.tr("Localizable", "listing.empty.title")
  /// Something happened
  internal static let listingErrorTitle = L10n.tr("Localizable", "listing.error.title")
  /// Delete this talk
  internal static let talkDelete = L10n.tr("Localizable", "talk.delete")
  /// Add a talk
  internal static let talkAddTitle = L10n.tr("Localizable", "talk.add.title")
  /// Scheduled at
  internal static let talkDateAlarm = L10n.tr("Localizable", "talk.date.alarm")
  /// Decided yet?
  internal static let talkDateAsk = L10n.tr("Localizable", "talk.date.ask")
  /// just now
  internal static let talkDateNow = L10n.tr("Localizable", "talk.date.now")
  /// Schedule date
  internal static let talkDateTitle = L10n.tr("Localizable", "talk.date.title")
  /// Awesome talk title
  internal static let talkNamePlaceholder = L10n.tr("Localizable", "talk.name.placeholder")
  /// Title
  internal static let talkNameTitle = L10n.tr("Localizable", "talk.name.title")
  /// Notes
  internal static let talkNotesTitle = L10n.tr("Localizable", "talk.notes.title")
  /// Name
  internal static let talkSpeakerNamePlaceholder = L10n.tr("Localizable", "talk.speaker.name.placeholder")
  /// Speaker
  internal static let talkSpeakerNameTitle = L10n.tr("Localizable", "talk.speaker.name.title")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
