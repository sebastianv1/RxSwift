//
//  RxSignal.swift
//  RxSwift
//
//  Created by Sebastian Edward Shanus on 1/21/20.
//  Copyright © 2020 Krunoslav Zaher. All rights reserved.
//

import Foundation


public struct RxSignal<E>: RxSignalConvertibleType {
    let source: Observable<E>
    
    init(source: Observable<E>) {
        self.source = source
    }
    
    public init(generator: (AnyObserver<E>) -> Void) {
        let subject = PublishSubject<E>()
        self.source = subject
        generator(subject.asObserver())
    }
    
    public static func pipe() -> (RxSignal<E>, AnyObserver<E>) {
        let subject = PublishSubject<E>()
        return (RxSignal<E>(source: subject.asObservable()), subject.asObserver())
    }
    
    public func asRxSignal() -> RxSignal<E> {
        return self
    }
    
    public func asObservable() -> Observable<E> {
        return source.asObservable()
    }
}

public protocol RxSignalConvertibleType: ObservableConvertibleType {
    func asRxSignal() -> RxSignal<E>
}

extension RxSignalConvertibleType {
    public func emitValues(_ on: @escaping (Event<E>) -> Void) -> Disposable {
        return self.asObservable().subscribe(on)
    }
    
    public func map<R>(_ transform: @escaping (E) throws -> R)
        -> RxSignal<R> {
        return RxSignal<R>(source: self.asObservable().map(transform))
    }
    
    public func flatMap<R>(_ selector: @escaping (E) throws -> RxSignal<R>)
        -> RxSignal<R> {
        return RxSignal<R>(source: self.asObservable().flatMap(selector))
    }
}
