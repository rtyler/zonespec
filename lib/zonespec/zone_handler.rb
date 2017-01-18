require 'zonespec'

require 'dnsruby'

module Zonespec
  class ZoneHandler
    attr_reader :resolver, :dns_server

    def initialize(name, dns_server)
       @zone_name = name
       @dns_server = dns_server

       @resolver = Dnsruby::Resolver.new
       @resolver.nameserver = @dns_server
    end

    def to_s
      return "Zone for #{@zone_name}"
    end

    def serves_a_record?(name, host)
      type = 'A'
      fqdn = "#{name}.#{@zone_name}"
      response = resolver.query(fqdn, type, 'IN')
      answers = response.answer.select { |a| a.type == type }
      answers.first.address.to_s == host
    end

    def serves_cname?(name, host)
      type = 'CNAME'
      # if the CNAME ends with a dot, then it's already a FQDN
      # if the host ends with a dot, then it's already a FQDN
      fqdn = "#{name}.#{@zone_name}"
      fqdn_host = "#{host}.#{@zone_name}"

      if name.end_with? '.'
        fqdn = name
      end

      # If the expected hostname ends with a dot, then that means the end
      # should be chopped off
      if host.end_with? '.'
        fqdn_host = host[0 ... -1]
      end

      begin
        response = resolver.query(fqdn, type, 'IN')
        answers = response.answer.select { |a| a.type == type }

        answers.first.domainname.to_s == fqdn_host
      rescue Exception => e
        puts e
        false
      end
    end
  end
end
