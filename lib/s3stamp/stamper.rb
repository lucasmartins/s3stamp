require 'openssl'
require 'digest/sha1'
require 'base64'

module S3Stamp::Stamper
  module ClassMethods
    def url_for(options)
      defaults(options)
      validate(options)
      if options[:acl]=='public-read'
        acl_string = "x-amz-acl:public-read\n"
      end
      target_string = "#{options[:method]}\n\n\n#{options[:expire_date]}\n#{acl_string}/#{options[:s3_bucket]}/#{options[:file_key]}"
      hmac = OpenSSL::HMAC.digest(digest, options[:s3_secret], target_string)
      signature = encode_signs(URI.escape(Base64.encode64(hmac).strip))
      "https://s3.amazonaws.com/#{options[:s3_bucket]}/#{options[:file_key]}?AWSAccessKeyId=#{options[:s3_key]}&Expires=#{options[:expire_date]}&Signature=#{signature}"
    end

    # one day jRuby will support keyword arguments...
    def defaults(options)
      options[:method] = options[:method].to_s.upcase if options[:method]
      options[:method] = 'GET' unless options[:method]
      options[:s3_bucket] = ENV['AWS_S3_BUCKET'] unless options[:s3_bucket]
      options[:s3_key] = ENV['AWS_S3_KEY'] unless options[:s3_key]
      options[:s3_secret] = ENV['AWS_S3_SECRET'] unless options[:s3_secret]
      options[:expire_date] = Time.now.to_i+900 unless options[:expire_date]
      options[:s3_bucket] = ENV['AWS_S3_BUCKET'] unless options[:s3_bucket]
      options
    end

    def validate(options)
      mandatory_keys = [:file_key]
      mandatory_keys.each do |key|
        raise "Must pass a key :#{key}" unless options.has_key?(key)
      end
    end

    def digest
      OpenSSL::Digest.new('sha1')
    end

    def encode_signs(string)
      signs = {'+' => "%2B", '=' => "%3D", '?' => '%3F', '@' => '%40',
        '$' => '%24', '&' => '%26', ',' => '%2C', '/' => '%2F', ':' => '%3A',
        ';' => '%3B', '?' => '%3F'}
      signs.keys.each do |key|
        string.gsub!(key, signs[key])
      end
      string
    end
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
