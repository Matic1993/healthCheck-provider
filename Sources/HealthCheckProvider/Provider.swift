import Vapor

public final class Provider: Vapor.Provider {
    public static var repositoryName: String = "healthCheck-provider"
    public var healthCheckUrl: String?
    
    public init(config: Config) throws {
        if let healthCheckUrl = config["healthCheck", "url"]?.string {
            self.healthCheckUrl = healthCheckUrl
        }
    }
    
    public func boot(_ config: Config) throws { }
    
    public func boot(_ droplet: Droplet) throws {
        guard let healthCheckUrl = self.healthCheckUrl else {
          return droplet.console.warning("MISSING: healthCheck.json config in Config folder. HealthCheck URL not addded.")
        }
        
        droplet.get(healthCheckUrl) { req in
          return try Response(status: .ok, json: JSON(["status": "up"]))
        }
    }
    
    public func beforeRun(_ droplet: Droplet) throws { }
}
