import Vapor
import FluentSQLite

/// Called after your application has initialized.
public func boot(_ app: Application) throws {

  _ = try app.connectionPool(to: .sqlite).withConnection { conn in
    Talk.query(on: conn).all().map { talks in
      guard talks.isEmpty else { return }

      mockData(conn: conn)
    }
  }

}

func mockData(conn: SQLiteConnection) {

  let t1 = Talk(title: "Understanding Combine"); t1.speakerName = "Daniel Steinberg"
  t1.date = Date(timeIntervalSince1970: 1570436400000)
  t1.notes = """
  Whether you are ready to go all in on SwiftUI or you prefer to stay with UIKit for now you’ll want to begin using the Combine framework in your apps. In this talk we build on your insights from working with Swift sequences such as Arrays, Dictionaries, and Sets to build an intuition about Combine. We’ll transform the way you talk about the flow of data into code. You’ll apply what we know about collections that are indexed over space to those that are indexed over time.
  """
  _ = t1.save(on: conn)

  let t2 = Talk(title: "SwiftUI & Redux"); t2.speakerName = "Thomas Ricouard"
  t2.date = Date(timeIntervalSince1970: 1570441200000)
  _ = t2.save(on: conn)

  let t3 = Talk(title: "Empower Your UITableView DataSources with a Flexible Model")
  t3.speakerName = "Denis Poifol"
  t3.date = Date(timeIntervalSince1970: 1570456200000)
  _ = t3.save(on: conn)

  let t4 = Talk(title: "Note encryption: 10 lines for encryption, 1500 lines for key management")
  t4.speakerName = "Anastasiia Voitova"
  t4.date = Date(timeIntervalSince1970: 1570521000000)
  _ = t4.save(on: conn)

  let t5 = Talk(title: "Building Voice-First Apps")
  t5.speakerName = "Elaine Dias Batista"
  t5.notes = """
  When we think about developing features that are voice-forward, we think about existing voice assistants such as Alexa and Siri. What about the fully-capable computers that we have with us all the time, our smartphones? Some moments on our day to day life are very well suited for voice interactions: while in a car or cooking for example. Let’s not forget that voice interactions are extremely accessible, not only in a physical way (for people with dexterity or motion impediments) but also in a cognitive way (I think we all have a loved one in our lives that really struggles with technology, and people from some emerging countries have very limited access to computers and are not at ease with technology).

  In this talk, I’ll explain what integrations can be done in iOS: - 1st-party solutions such as the Natural Language Framework and Siri Shortcuts - 3rd-party solutions such as Porcupine, Snips, Dialogflow, Amazon Lex, RASA and many others for each one, I’ll discuss the main characteristics - On device vs. Cloud - Open or Closed source - Pricing - Performance

  In summary, this talk will help think about why you should implement conversational features on your app and how.
  """
  t5.date = Date(timeIntervalSince1970: 1570528500000)
  _ = t5.save(on: conn)
}
