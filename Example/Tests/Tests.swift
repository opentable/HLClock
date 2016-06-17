// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import HLClock

class HLCSpec: QuickSpec {
    override func spec() {
        describe("Test core hlc algorithm") {
            
            // initial time
            let t = Int64(1465844716)
            
            // Internal clock state of two nodes
            var node_a:(l:Int64,c:Int64) = (0, 0)
            var node_b:(l:Int64,c:Int64) = (0, 0)
            
            // Node a sends a message
            node_a = hlc_send(node_a, pt: t)
            let message_a = node_a
            
            // Node b receives message from node a
            node_b = hlc_recv(node_b, m: message_a, pt: t+1)
            
            // Node b generates two messages simultaniously
            node_b = hlc_send(node_b, pt: t+2)
            let message_b = node_b
            node_b = hlc_send(message_b, pt: t+2)
            let message_c = node_b
            
            // Node a receives messages from b
            node_a = hlc_recv(node_a, m: message_b, pt: t+3)
            node_a = hlc_recv(node_a, m: message_c, pt: t+3)
            
            it("node a generates a message with initial time t") {
                expect(message_a.l) == t
                expect(message_a.c) == 0
            }
            
            it("node b generates a message after receiving message_a") {
                expect(message_b.l) == t+2
                expect(message_b.c) == 0
            }
            
            it("node b generates a second message") {
                expect(message_c.l) == t+2
                expect(message_c.c) == 1
            }
            
            it("node a receives both messages from b") {
                expect(node_a.l) == t+3
                expect(node_a.c) == 1
            }
        }
    }
}