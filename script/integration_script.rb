#!/usr/bin/env ruby
require 'faraday'
require 'securerandom'
require 'json'

PET_URL = "https://wunder-pet-api-staging.herokuapp.com"
API_KEY = "UXhygiNEP1vYvRuPA4EluyJxLnscJ6uerTsUlnObFUqKxoyCnN"
ARENA_URL = "http://localhost"
ARENA_PORT = 3000

pet_conn = Faraday.new(url: PET_URL) do |faraday|
  faraday.adapter Faraday.default_adapter
  faraday.headers["X-Pets-Token"] = API_KEY
  faraday.headers['Content-Type'] = 'application/json'
end

arena_conn = Faraday.new(url: ARENA_URL) do |faraday|
  faraday.port = 3000
  faraday.adapter Faraday.default_adapter
  faraday.headers['Content-Type'] = 'application/json'
end

def new_pet
  { 
    "name": SecureRandom.hex(5), 
    "strength": Random.rand(100), 
    "intelligence": Random.rand(100), 
    "speed": Random.rand(100), 
    "integrity": Random.rand(100) 
  }
end

def create_pet(pet_conn)
  pet_conn.post do |req|
    req.url('/pets')
    req.body = JSON.generate(new_pet)
  end
end

def print_data(msg, data)
  puts "=== #{msg.upcase} ==="
  puts data
  puts
  puts
end

first_pet_response = create_pet(pet_conn)
second_pet_response = create_pet(pet_conn)
first_pet_id = JSON.parse(first_pet_response.body)["id"]
second_pet_id = JSON.parse(second_pet_response.body)["id"]

print_data("first pet", first_pet_response.body)
print_data("second pet", second_pet_response.body)

contest_types_response = arena_conn.get('/contest_types')

print_data("current available contests", contest_types_response.body)

new_contest = {
  contest: {
    first_competitor: first_pet_id,
    second_competitor: second_pet_id,
    type: 'potato_racing'
  }
}

contest_creation_response = arena_conn.post do |req|
  req.url('/contests')
  req.body = JSON.generate(new_contest)
end

print_data("created contest", contest_creation_response.body)

contest_id = JSON.parse(contest_creation_response.body)["contest"]["id"]

sleep 5

contest_finished_response = arena_conn.get("/contests/#{contest_id}")

print_data("finished_contest", contest_finished_response.body)
