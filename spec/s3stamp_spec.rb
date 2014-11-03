require 'spec_helper'

describe S3Stamp, 'linking' do
  it 'loads correctly' do
    expect { S3Stamp.url_for(file_key: 'test.txt') }.not_to raise_error
  end
end
