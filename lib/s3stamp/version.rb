# Keeps the versioning clean and simple.
module S3Stamp
  module Version
    MAJOR = 0
    MINOR = 0
    PATCH = 0
    ALPHA = '.pre.1' # ex: '.pre.1'
    STRING = "#{MAJOR}.#{MINOR}.#{PATCH}#{ALPHA}"
  end
end
