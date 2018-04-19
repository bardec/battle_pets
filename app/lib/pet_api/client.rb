require 'faraday'

module PetApi
  class Client
    URL = "https://wunder-pet-api-staging.herokuapp.com"
    API_KEY = "UXhygiNEP1vYvRuPA4EluyJxLnscJ6uerTsUlnObFUqKxoyCnN"

    def self.get(pet_id:)
      conn.get("/pets/#{pet_id}")
    end

    private

    def self.conn
      Faraday.new(url: URL) do |faraday|
        faraday.adapter Faraday.default_adapter
        #TODO don't leave this
        faraday.headers["X-Pets-Token"] = API_KEY
        faraday.headers['Content-Type'] = 'application/json'
      end
    end
  end
end
