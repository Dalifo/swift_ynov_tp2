// TP2 - Card Game System
// Card Game Manager with Singleton Pattern

import Foundation

// Game Manager avec singleton pattern
final class CardGameManager {
    static let shared = CardGameManager()

    private init() {}

    // 3. CLASS DECK
    final class Deck {
        private(set) var cards: [Card] = []

        init() {
            reset()
        }

        private func generateFullDeck() -> [Card] {
            var newCards: [Card] = []
            for suit in Suit.allCases {
                for rank in Rank.allCases {
                    newCards.append(Card(rank: rank, suit: suit))
                }
            }
            return newCards
        }

        func shuffle() {
            cards.shuffle()
        }

        func draw() -> Card? {
            guard !cards.isEmpty else { return nil }
            return cards.removeFirst()
        }

        func reset() {
            cards = generateFullDeck()
            shuffle()
        }
    }

    // 4. PROTOCOL PLAYER
    protocol Player: AnyObject {
        var name: String { get }
        var hand: [Card] { get set }
        var score: Int { get set }

        func playCard() -> Card?
        func receiveCard(_ card: Card)
    }

    // 5. CLASSES PLAYERS
    final class HumanPlayer: Player {
        let name: String
        var hand: [Card] = []
        var score: Int = 0

        init(name: String) {
            self.name = name
        }

        func playCard() -> Card? {
            guard !hand.isEmpty else { return nil }
            return hand.removeFirst()
        }

        func receiveCard(_ card: Card) {
            hand.append(card)
        }
    }

    final class AIPlayer: Player {
        let name: String
        var hand: [Card] = []
        var score: Int = 0

        init(name: String) {
            self.name = name
        }

        func playCard() -> Card? {
            guard !hand.isEmpty else { return nil }
            return hand.removeFirst()
        }

        func receiveCard(_ card: Card) {
            hand.append(card)
        }
    }

    // 6. CLASS GAME
    final class Game {
        let player1: Player
        let player2: Player
        let deck: Deck

        private var roundNumber = 0

        init(player1: Player, player2: Player, deck: Deck = Deck()) {
            self.player1 = player1
            self.player2 = player2
            self.deck = deck
        }

        func dealCards() {
            print("Dealing cards...")

            var toggle = true
            while let card = deck.draw() {
                if toggle {
                    player1.receiveCard(card)
                } else {
                    player2.receiveCard(card)
                }
                toggle.toggle()
            }

            print("\(player1.name) received \(player1.hand.count) cards")
            print("\(player2.name) received \(player2.hand.count) cards\n")
        }

        func play() {
            dealCards()

            while !player1.hand.isEmpty && !player2.hand.isEmpty {
                playRound()
            }

            print("\n=== GAME OVER ===")
            if player1.score > player2.score {
                print("Winner: \(player1.name) with \(player1.score) points!")
            } else if player2.score > player1.score {
                print("Winner: \(player2.name) with \(player2.score) points!")
            } else {
                print("It's a tie with \(player1.score) points each!")
            }
            print("Final score: \(player1.name) \(player1.score) - \(player2.name) \(player2.score)")
        }

        func playRound() {
            roundNumber += 1
            print("--- Round \(roundNumber) ---")

            guard let c1 = player1.playCard(), let c2 = player2.playCard() else {
                return
            }

            print("\(player1.name) plays: \(c1.description)")
            print("\(player2.name) plays: \(c2.description)")

            if c1.rank > c2.rank {
                player1.score += 1
                print("\(player1.name) wins this round!")
                printScore()
                print("")
                return
            }

            if c2.rank > c1.rank {
                player2.score += 1
                print("\(player2.name) wins this round!")
                printScore()
                print("")
                return
            }

            handleWar(tiedRank: c1.rank)
            printScore()
            print("")
        }

        private func handleWar(tiedRank: Rank) {
            print("War! Both played \(tiedRank.name)!")
            print("Each player plays 3 cards face down...")

            while true {
                if player1.hand.count < 4 {
                    player2.score += 1
                    print("\(player1.name) doesn't have enough cards for war. \(player2.name) wins the war!")
                    return
                }
                if player2.hand.count < 4 {
                    player1.score += 1
                    print("\(player2.name) doesn't have enough cards for war. \(player1.name) wins the war!")
                    return
                }

                _ = player1.playCard()
                _ = player1.playCard()
                _ = player1.playCard()

                _ = player2.playCard()
                _ = player2.playCard()
                _ = player2.playCard()

                guard let warCard1 = player1.playCard(), let warCard2 = player2.playCard() else {
                    return
                }

                print("\(player1.name) plays: \(warCard1.description)")
                print("\(player2.name) plays: \(warCard2.description)")

                if warCard1.rank > warCard2.rank {
                    player1.score += 1
                    print("\(player1.name) wins the war!")
                    return
                } else if warCard2.rank > warCard1.rank {
                    player2.score += 1
                    print("\(player2.name) wins the war!")
                    return
                } else {
                    print("War again!")
                }
            }
        }

        private func printScore() {
            print("Score: \(player1.name) \(player1.score) - \(player2.name) \(player2.score)")
        }
    }

    // 8. SIMULATION
    func run() {
        print("Card Game: War")
        print("=================\n")

        // Bien évidemment, le résultat ne sera pas forcément réaliste : Ynov gagne toujours.
        let player1 = HumanPlayer(name: "Sascha Salles")
        let player2 = AIPlayer(name: "Staff Ynov")

        let game = Game(player1: player1, player2: player2)
        game.play()
    }
}

// 7. EXTENSIONS
extension Array where Element == Card {
    func highest() -> Card? {
        self.max()
    }

    var description: String {
        self.map { $0.description }.joined(separator: ", ")
    }
}
