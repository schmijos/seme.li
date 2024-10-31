require "spec-kemal"
require "../src/storage"
require "../src/semel"

describe "Semel" do
  after_each do
    File.delete?("./data/test.db")
  end

  it "renders the home page for entering secrets" do
    get "/"
    response.body.should contain "Renuo"
  end

  it "renders the page to retrieve a secret" do
    get "/try"
    response.body.should contain "Renuo"
  end

  # it "renders json with the link to the secret" do
  #   post "/create", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {"ciphertext": "XXX", "expires_in_seconds": 30}.to_json
  #   puts response.body
  #   url = Hash(String, String).from_json(response.body)["url"].as(String)
  #   url.should match(/https:\/\/seme.li\/try#.*/)
  # end

  # it "renders the secret (and only once)" do
  #   post "/create", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {"ciphertext": "XXX", "expires_in_seconds": 30}.to_json
  #   id = Hash(String, String).from_json(response.body)["url"].as(String).split("#").last

  #   delete "/consume/#{id}"
  #   puts response.body
  #   response.status_code.should eq(200)
  #   Hash(String, String).from_json(response.body)["ciphertext"].as(String).should eq "LOLSECRET"

  #   delete "/consume/#{id}"
  #   response.status_code.should eq(400)
  #   response.body.should eq ""
  # end
end
