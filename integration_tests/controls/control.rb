#!/usr/bin/env ruby
#
# -*- mode: ruby -*-
# vi: set ft=ruby :
#

token     = attribute('token', description: 'token for vault')
url       = attribute('url', description: 'url for vault')
namespace = attribute('namespace', description: 'namespace for vault')
path      = attribute('path', description: 'path for vault')

title "Vault Integration Test"

control "vlt-1.0" do
  impact 0.7
  title "Test access to GCP secret"
  desc "Test access to GCP secret"
  describe http("#{url}/v1/#{namespace}/#{path}",
              method: 'GET',
              headers: {'X-Vault-Token' => "#{token}"}) do
    its('status') { should eq 200 }
  end
end

control "vlt-2.0" do
  impact 0.7
  title "Test health"
  desc "Test health"
  describe http("#{url}/v1/sys/health?perfstandbyok=true",
              method: 'GET') do
    its('status') { should eq 200 }
  end
end
