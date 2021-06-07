#!/usr/bin/env ruby
#
# -*- mode: ruby -*-
# vi: set ft=ruby :
#

content = inspec.profile.file('terraform.json')
params = JSON.parse(content)

token          = params['token']['value']
rotation_token = params['rotation_token']['value']
url            = params['url']['value']
namespace      = params['namespace']['value']
path           = params['path']['value']
rotation_path  = params['rotation_path']['value']

token_lookup = JSON.generate({:token => "#{token}"})

title "Vault Integration Test"

control 'vlt-1.0' do
  impact 0.7
  title 'Ensure token has correct policies'
  desc 'Ensure token has correct policies'
  describe json(content: http("#{url}/v1/auth/token/lookup",
              method: 'POST',
              data: token_lookup.to_s,
              headers: {'X-Vault-Token' => "#{token}"}).body) do
    its(['data', 'identity_policies']) { should include 'gcp-creds-tmpl' }
    its(['data', 'identity_policies']) { should_not include 'admin' }
  end
end

control "vlt-2.0" do
  impact 0.7
  title "Successful deny of prod GCP Credentials by dev vault identity"
  desc "Successful deny of prod GCP Credentials by dev vault identity"
  describe http("#{url}/v1/#{namespace}token/prod-db",
              method: 'GET',
              headers: {'X-Vault-Token' => "#{token}"}) do
    its('status') { should eq 403 }
  end
end

control "vlt-3.0" do
  impact 0.7
  title "Validate access to Dev GCP Credentials"
  desc "Validate access to Dev GCP Credentials"
  describe http("#{url}/v1/#{namespace}#{path}",
              method: 'GET',
              headers: {'X-Vault-Token' => "#{token}"}) do
    its('status') { should eq 200 }
  end
end

control "vlt-4.0" do
  impact 0.7
  title "Validate successful root credential rotation"
  desc "Validate successful root credential rotation"
  describe http("#{url}/v1/#{namespace}#{rotation_path}",
              method: 'POST',
              headers: {'X-Vault-Token' => "#{rotation_token}"}) do
    its('status') { should eq 200 }
  end
end

control "vlt-5.0" do
  impact 0.7
  title "Test health"
  desc "Test health"
  describe http("#{url}/v1/sys/health?perfstandbyok=true",
              method: 'GET') do
    its('status') { should eq 200 }
  end
end
