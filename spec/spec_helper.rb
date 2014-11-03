require 'pry'
require 'pry-nav'
require 's3stamp'
require 'rspec'
require 'rspec/mocks'
require 'rspec/expectations'
require 'pathname'
require 'vcr'
require 'webmock'
require 'webmock/rspec'
require 'timecop'

SPECDIR = Pathname.new(File.dirname(__FILE__))
TMPDIR = SPECDIR.join('tmp')

RSpec.configure do |config|
  config.order = :random
  config.before { FileUtils.mkdir_p(TMPDIR) }
  config.mock_with :rspec

  WebMock.disable_net_connect!
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
