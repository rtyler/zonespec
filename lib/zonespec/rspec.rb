require 'zonespec'
require 'zonespec/dns_server'
require 'zonespec/zone_handler'

module Zonespec
  module RSpec
    module Global
      def dns_server(*args)
        Zonespec::DNS_Server.new(*args)
      end
    end

    module Nested
      def zone(*args)
        @@zone_name = args.first
        if args.size > 1
          @@zone_file = args.last
        end
        Zonespec::ZoneHandler.new(@@zone_name,
                                  self.described_class.hostname)
      end

      def verify_all_a_records!
        load_file.a.each do |record|
          next if record[:name] == '@'
          it { should serve_a_record(record[:name], record[:host]) }
        end
      end

      def verify_all_cnames!
        load_file.cname.each do |cname|
          host = cname[:host]
          if host == '@'
            host = "#{@@zone_name}."
          end
          it { should serve_cname(cname[:name], host) }
        end
      end

      private
      def load_file
        Zonefile.from_file(@@zone_file)
      end
    end
  end
end

extend Zonespec::RSpec::Global
class RSpec::Core::ExampleGroup
  extend Zonespec::RSpec::Nested
end


RSpec::Matchers.define :serve_cname do |name, host|
  match do |zone|
    raise "Must use within zone()" unless zone.kind_of? Zonespec::ZoneHandler
    zone.serves_cname?(name, host)
  end

  description do |zone|
    "serve the CNAME `#{name}` for `#{host}`"
  end
end

RSpec::Matchers.define :serve_a_record do |name, host|
  match do |zone|
    raise "Must use within zone()" unless zone.kind_of? Zonespec::ZoneHandler
    zone.serves_a_record?(name, host)
  end

  description do |zone|
    "serve the A record `#{name}` => `#{host}`"
  end
end
