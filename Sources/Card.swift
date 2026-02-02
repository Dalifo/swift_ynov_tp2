// TP2 - Card Game System
// Card Model

import Foundation

// 1. ENUMS (1 point)
// Code fourni - Décommenter et compléter

enum Suit: String, CaseIterable {
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    case spades = "♠️"
}

enum Rank: Int, CaseIterable, Comparable {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace

    // TODO: Ajouter computed property name qui retourne "2", "3", ..., "Jack", "Queen", "King", "Ace"

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// 2. STRUCT CARD (2 points)
// TODO: Implémenter la structure Card

// struct Card: Comparable {
//     // TODO: Ajouter les propriétés rank et suit
//
//     // TODO: Computed property description qui retourne "Ace of ♠️"
//     var description: String {
//         return ""
//     }
//
//     // TODO: Implémenter Comparable (comparer par rank)
//     static func < (lhs: Card, rhs: Card) -> Bool {
//         return false
//     }
// }
