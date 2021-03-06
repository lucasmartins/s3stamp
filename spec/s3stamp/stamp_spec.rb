require 'spec_helper'
require 'ostruct'

describe S3Stamp::Stamper do
  let(:duck) do
    object = Object.new
    object.extend(S3Stamp::Stamper::ClassMethods)
    object
  end

  before(:each) do
    t = Time.local(2014, 11, 2, 22, 04, 00)
    Timecop.freeze(t)
    # using fake SSL sha1 from Vagrant box
    fake = OpenSSL::Digest.new('sha1')
    allow(fake).to receive(:digest).and_return("\xDA9\xA3\xEE^kK\r2U\xBF\xEF\x95`\x18\x90\xAF\xD8\a\t")
    allow(S3Stamp).to receive(:digest).and_return(fake)
  end
  after(:each) do
    Timecop.return
  end

  describe '.url_for' do
    it 'generates an URL for download' do
      url = duck.url_for(file_key: 'test.txt')
      VCR.use_cassette('url_for.get', record: :once, match_requests_on: [:method, :uri, :headers]) do
        request = Typhoeus::Request.new url, method: :get
        request.on_headers do |response|
          expect(response.code).to eq(200)
        end
        request.run
      end
    end

    it 'generates a VALID URL for upload' do
      url = duck.url_for(file_key: 'test.txt', method: :put)
      VCR.use_cassette('url_for.put', record: :once, match_requests_on: [:method, :uri, :headers]) do
        request = Typhoeus::Request.new url, method: :put, body: 'pretty body'
        request.on_headers do |response|
          expect(response.code).to eq(100)
        end
        request.run
      end
    end

    it 'generates a VALID URL for upload with public-read ACL' do
      url = duck.url_for(file_key: 'test.txt', method: :put, acl: 'public-read')
      VCR.use_cassette('url_for.put_with_acl', record: :once) do
        request = Typhoeus::Request.new url, method: :put, body: 'pretty body', headers: {'X-Amz-Acl' => 'public-read'}
        request.on_headers do |response|
          expect(response.code).to eq(200)
        end
        request.run
      end
    end
  end
end
