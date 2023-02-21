require "kemal"
require "./storage"

serve_static false

storage = Storage.new(ENV["KEMAL_ENV"]? || "development")

get "/" do
  render "src/views/new.ecr", "src/views/layout.ecr"
end

get "/try" do
  render "src/views/try.ecr", "src/views/layout.ecr"
end

post "/create" do |env|
  env.response.content_type = "application/json"

  ciphertext = env.params.json["ciphertext"].as(String)
  content_type = env.params.json["content_type"].as(String)
  expires_in_seconds = env.params.json["expires_in_seconds"].as(Int64)
  secret_id = storage.put(ciphertext, content_type, Time.utc.to_unix + expires_in_seconds)

  { url: "https://seme.li/try##{secret_id}" }.to_json
end

delete "/consume/:id" do |env|
  env.response.content_type = "application/json"

  storage.cut
  secret_id = env.params.url["id"].as(String)
  result = storage.consume(secret_id)

  halt env, 400, "{}" unless result # actually 404, but Kemal then renders HTML?!

  ciphertext, content_type = result.as(Tuple(String, String))

  { ciphertext: ciphertext, contentType: content_type }.to_json
end

Kemal.run
