# frozen_string_literal: true

# monkey patch
module Whenever
  class JobList
    attr_reader :roles

    def self.respond_to?(name, include_private = false)
      @set_variables&.has_key?(name) || super
    end
  end
end