module Requests
  module JsonHelpers
    def parsed_body
      JSON.parse(response.body)
    end
  end
end
