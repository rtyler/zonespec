require 'zonespec'

require 'dnsruby'

module Zonespec
  class ZoneHandler
    def initialize(name, dns_server)
       @zone_name = name
       @dns_server = dns_server
    end

    def to_s
      return "Zone for #{@zone_name}"
    end

    def serves_cname?(name, host)
      fqdn = "#{name}.#{@zone_name}"
      fqdn_alias = "#{host}.#{@zone_name}"
      begin
        resolver = Dnsruby::Resolver.new
        resolver.nameserver = @dns_server
        r = resolver.query(fqdn, 'CNAME', 'IN')
        answers = r.answer.select { |a| a.type == 'CNAME' }
        if host.end_with? '.'
          answers.first.domainname.to_s == host[0 ... -1]
        else
          answers.first.domainname.to_s == fqdn_alias
        end
      rescue Exception => e
        puts e
        false
      end
    end
  end
end
