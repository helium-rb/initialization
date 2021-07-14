require "helium/initialization/version"

module Helium
  module Initialization
    def self.included(mod)
      mod.extend ClassMethods
      mod.prepend Initialize
    end
  end

  module ClassMethods
    def before_initialize(&block)
      initialization[:before] << block
    end

    def after_initialize(&block)
      initialization[:after] << block
    end

    def initialization
      @initialization ||= {
        before: [],
        after: []
      }.freeze
    end
  end

  module Initialize
    def initialize(*)
      self.class.initialization[:before].each { |block| instance_exec(&block) }
      super
      self.class.initialization[:after].each { |block| instance_exec(&block) }
    end
  end
end
