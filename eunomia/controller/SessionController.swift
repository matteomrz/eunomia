//
//  SessionController.swift
//  eunomia
//
//  Created by Matteo Merz on 14.11.26.
//

import Foundation
import SwiftData

@MainActor @Observable
final class SessionController {
    var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func startSession(for goal: Goal) throws -> UUID {
        let session = Session(goal: goal, start: Date.now)
        context.insert(session)
        try context.save()
        return session.uuid
    }

    func endSession(_ uuid: UUID) throws {
        let descriptor = FetchDescriptor<Session>(
            predicate: #Predicate { $0.uuid == uuid }
        )
        guard let session = try context.fetch(descriptor).first else {
            throw DataError.notFound(Session.self, uuid)
        }
        session.end = Date.now
        try context.save()
    }
}
