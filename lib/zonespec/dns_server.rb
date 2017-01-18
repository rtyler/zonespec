require 'zonespec'

require 'zonefile'

module Zonespec
  class DNS_Server
    attr_reader :hostname

    def initialize(hostname)
      @hostname = hostname
      @zonefile = nil
    end

    def to_s
      return "DNS Server at #{hostname}"
    end
  end
end
