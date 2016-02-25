require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/rspec/vcr'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
  c.allow_http_connections_when_no_cassette = false

  c.filter_sensitive_data('<SIR_HANDEL_USERNAME>') { ENV['SIR_HANDEL_USERNAME'] }
  c.filter_sensitive_data('<SIR_HANDEL_PASSWORD>') { ENV['SIR_HANDEL_PASSWORD'] }

  c.configure_rspec_metadata!
end
