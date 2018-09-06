module ActsAsAlertable
  class Configuration
    attr_accessor :alertables, :alerteds

    def initialize
      alertables = []
      alerteds = []
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.setup
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end