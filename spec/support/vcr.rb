require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.register_request_matcher :any_pet_matcher  do |request_1, request_2|
    !!(request_1.uri.to_s =~ /https:\/\/wunder-pet-api-staging\.herokuapp\.com\/pets\/[a-z0-9-]+/)
  end
end

