//
//  RxSignalProducer.swift
//  RxSwift
//
//  Created by Sebastian Edward Shanus on 1/21/20.
//  Copyright © 2020 Krunoslav Zaher. All rights reserved.
//

import Foundation

public struct RxSignalProducer<E>: RxSignalProducerConvertibleType {
    private let source: Observable<E>
    
    public init(generator: @escaping (AnyObserver<E>) -> Disposable) {
        self.source = Observable.deferred {
            return Observable.create(generator)
        }
    }

    init(source: Observable<E>) {
        self.source = Observable.deferred { source }
    }
    
    public func asRxSignalProducer() -> RxSignalProducer<E> {
        return self
    }
    
    public func asObservable() -> Observable<E> {
        return source
    }
}

public protocol RxSignalProducerConvertibleType: ObservableConvertibleType {
    func asRxSignalProducer() -> RxSignalProducer<E>
}

extension RxSignalProducer {
    public static func empty() -> RxSignalProducer<E> {
        return RxSignalProducer(source: Observable<E>.empty())
    }
}

extension RxSignalProducerConvertibleType {
    public func subscribeValues(_ on: @escaping (Event<E>) -> Void) -> Disposable {
        return self.asObservable().subscribe(on)
    }
    
    public func map<R>(_ transform: @escaping (E) throws -> R)
        -> RxSignalProducer<R> {
            return RxSignalProducer<R>(source: self.asObservable().map(transform))
    }
    
    public func flatMap<R>(_ selector: @escaping (E) throws -> RxSignalProducer<R>)
        -> RxSignalProducer<R> {
            return RxSignalProducer<R>(source: self.asObservable().flatMap(selector))
    }
}
