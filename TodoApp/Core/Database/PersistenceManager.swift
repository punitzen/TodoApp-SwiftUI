//
//  PersistenceManager.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import Foundation

protocol PersistenceManager {
    associatedtype ObjectType
    associatedtype PredicateType

    func create(_ object: ObjectType)
    func fetchFirst(_ objectType: ObjectType.Type, predicate: PredicateType?) -> Result<ObjectType?, Error>
    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType?, limit: Int?) -> Result<[ObjectType], Error>
    func update(_ object: ObjectType)
    func delete(_ object: ObjectType)
}
