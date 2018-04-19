require 'faraday'

module PetApi
  class Client
    def self.get(pet_id:)
      new.get(pet_id: pet_id)
    end

    def initialize(config: Rails.application.config_for(:pet_api))
      @url = config.fetch('url')
      @api_key = config.fetch('api_key')
    end

    def get(pet_id:)
      conn.get("/pets/#{pet_id}")
    end

    private
    attr_reader :url, :api_key

    def conn
      Faraday.new(url: url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers["X-Pets-Token"] = api_key
        faraday.headers['Content-Type'] = 'application/json'
      end
    end
  end
end
