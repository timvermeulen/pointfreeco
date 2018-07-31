import ApplicativeRouter
import Prelude

public protocol Newtype {
    associatedtype RawValue
    var rawValue: RawValue { get }
}

extension Newtype {
    public init(rawValue: RawValue) {
        self = unsafeBitCast(rawValue, to: Self.self)
    }
}

extension Newtype where Self: Equatable, RawValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Newtype where Self: Comparable, RawValue: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Newtype where Self: Hashable, RawValue: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

extension Newtype where Self: Encodable, RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}

extension Newtype where Self: Decodable, RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        self.init(rawValue: try RawValue(from: decoder))
    }
}

extension Newtype where RawValue: Numeric {
    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(rawValue: lhs.rawValue * rhs.rawValue)
    }
}

extension Newtype where RawValue: SignedNumeric {
    public static prefix func - (x: Self) -> Self {
        return .init(rawValue: -x.rawValue)
    }
}

extension Newtype where Self: ExpressibleByIntegerLiteral, RawValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: RawValue.IntegerLiteralType) {
        self.init(rawValue: RawValue(integerLiteral: value))
    }
}

extension Newtype where Self: ExpressibleByStringLiteral, RawValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: RawValue.StringLiteralType) {
        self.init(rawValue: RawValue(stringLiteral: value))
    }
}

extension PartialIso where B: Newtype, A == B.RawValue {
    public static var newtype: PartialIso<B.RawValue, B> {
        return PartialIso(
            apply: B.init,
            unapply: ^\.rawValue
        )
    }
}
