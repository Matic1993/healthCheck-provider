import XCTest
import Testing
@testable import HealthCheckProvider
@testable import Vapor

final class HealthCheckProviderTests: XCTestCase {
    
    override func setUp() {
        Testing.onFail = XCTFail
    }
    
    func testHealthCheck() {
      var config = try! Config(arguments: ["vapor", "--env=test"])
      try! config.set("healthCheck.url", "healthCheck")
      try! config.addProvider(HealthCheckProvider.Provider.self)
      let drop = try! Droplet(config)
      background {
        try! drop.run()
      }

      try! drop
        .testResponse(to: .get, at: "healthCheck")
        .assertStatus(is: .ok)
        .assertJSON("status", equals: "up")
    }
    
    static var allTests = [
      ("testHealthCheck", testHealthCheck),
    ]
    
}
