module Jumpstart
  module Multitenancy
    def self.domain?
      selected.include?("domain")
    end

    def self.subdomain?
      selected.include?("subdomain")
    end

    def self.path?
      selected.include?("path")
    end

    def self.session?
      true
    end

    def self.selected
      # Default to session cookie account switching if none specified
      # This is for backwards compatibility with the previous Team model
      Array.wrap(Jumpstart.config.multitenancy)
    end
  end
end
