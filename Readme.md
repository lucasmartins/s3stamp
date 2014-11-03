S3Stamp
=======

This Gem provides an easy way to generate S3 signed URLs so you can upload file to S3 with [Typhoeus](https://github.com/typhoeus/typhoeus), without any of that thread-unsafety non-sense from the `aws-s3` lib. Testing is majorly done using Typhoeus (libcurl wrap), but you will be fine using any http lib you want.

Main goal here is not to implement all features from S3, I'm writing what I need, feel free to send a Pull-Request with any extra support.

Install
=======

You can:
```
  $ gem install s3stamp
```

Or just add it to your Gemfile
```ruby
  gem 's3stamp'
```

Use
===

For Downloads:
```ruby
url = S3Stamp.url_for(
  file_key: 'test.txt',
  s3_bucket: 'my-bucket',
  s3_key: 'my-key',
  s3_secrey: 'my-secret',
  expire_date: Time.now.to_i)
```

`expire_date` will default to `Time.now.to_i+900`

You can also leave the S3 access info empty, `S3Stamp` will read them from the environment variables:
```ruby
ENV['AWS_S3_KEY']
ENV['AWS_S3_SECRET']
ENV['AWS_S3_BUCKET']
```

For Uploads:
```ruby
url = S3Stamp.url_for(
  file_key: 'test.txt',
  method: :put,
  acl: 'public-read')

request = Typhoeus::Request.new url, method: :put, body: 'pretty body', headers: {'X-Amz-Acl' => 'public-read'}
request.on_headers do |response|
  unless response.code==200
    raise "Couldn't upload file!\n#{response}"
  end
end
request.on_complete do |response|
  # do cool stuff here
end
request.run
```

That's it.

Contribute
==========

Just fork [S3Stamp](https://github.com/lucasmartins/s3stamp), add your feature+spec, and make a pull request. **DO NOT** mess up with the version file though.
  
Support
=======

This is an opensource project so don't expect premium support, but don't be shy, post any troubles you're having in the [Issues](https://github.com/lucasmartins/s3stamp/issues) page and we'll do what we can to help.

License
=======

Please see [LICENSE](https://github.com/lucasmartins/s3stamp/blob/master/LICENSE) for licensing details.
