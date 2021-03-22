#!/usr/bin/env ruby
#
# -*- mode: ruby -*-
# vi: set ft=ruby :
#

content = inspec.profile.file('terraform.json')
params = JSON.parse(content)

token     = params['token']['value']
url       = params['url']['value']
namespace = params['namespace']['value']
path      = params['path']['value']

title "Vault Integration Test"

control "vlt-1.0" do
  impact 0.7
  title "Test access to GCP secret"
  desc "Test access to GCP secret"
  describe http("#{url}/v1/#{namespace}#{path}",
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
