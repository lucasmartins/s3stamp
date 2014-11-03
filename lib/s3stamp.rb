require 'yaml'
require 'openssl'
require 'bundler'
require 'json'
require 'yajl-ruby' if RUBY_PLATFORM=='ruby'
require 'jruby-openssl' if RUBY_PLATFORM=='jruby'

begin
  require 'dotenv'
  Dotenv.load
rescue Exception => e
  "It seems that you're not at development evironment, so I won't load Dotenv."
end

Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

module S3Stamp
  require_relative 's3stamp/stamper'
  require_relative 's3stamp/version'

  include S3Stamp::Stamper

  # alias method
  def logger
    MailCannon.logger
  end

  # Returns the lib logger object
  def self.logger
    @logger || initialize_logger
  end

  # Initializes logger
  def self.initialize_logger(log_target = STDOUT)
    oldlogger = @logger
    @logger = Logger.new(log_target)
    @logger.level = Logger::INFO
    @logger.progname = 's3stamp'
    oldlogger.close if oldlogger && !$TESTING
    @logger
  end

end
