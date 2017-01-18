require 'spec_helper'
require 'zonespec/rspec'

describe dns_server('8.8.8.8') do
  describe zone('jenkins.io', 'spec/acceptance/jenkins.io.zone') do
    verify_all_cnames!
    verify_all_a_records!
  end

  describe zone('jenkins.io') do
    it { should serve_cname('www', 'jenkins.io.') }
  end
end



describe dns_server('localhost') do
  describe zone('example.com', 'spec/acceptance/example.com.zone') do
    #verify_all_cnames!
  end

  describe zone('example.com') do
    #it { pending "Need to get a local test server set up"; should serve_cname('ftp', 'www') }
  end
end
