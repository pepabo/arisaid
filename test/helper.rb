$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'arisaid'

require 'minitest/autorun'
require 'webmock/minitest'

ENV['SLACK_API_TOKEN'] = "xoxo-#{'0'*10}-#{'0'*10}-#{'0'*10}-#{'0'*6}"
ENV['SLACK_TEAM'] = 'foobar'

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    status: 200,
    headers: { :content_type => 'application/json; charset=utf-8' },
    body: fixture(file)
  }
end

def slack_url(url)
  return url if url =~ /^http/
  url = File.join(Slack::Web::Client.new.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.to_s
end

def stub_get(endpoint)
  stub_request(:get, slack_url(endpoint)).
    to_return json_response("#{endpoint}")
end
