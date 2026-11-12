require "spec-kemal"
require "../src/storage"
require "../src/semel"

describe "Semel" do
  after_each do
    File.delete?("./data/test.db")
  end

  it "renders the home page for entering secrets" do
    get "/"
    response.body.should contain "Semel"
  end

  it "renders the page to retrieve a secret" do
    get "/try"
    response.body.should contain "Semel"
  end

  it "restricts the page to retrieve a secret with a CSP" do
    get "/try"
    response.headers["Content-Security-Policy"]?.to_s.should contain "default-src 'none'"
  end

  it "forbids other sites to embed the page" do
    get "/"
    response.headers["Content-Security-Policy"]?.to_s.should contain "frame-ancestors 'none'"
  end

  it "does not let other sites read responses" do
    get "/"
    response.headers["Access-Control-Allow-Origin"]?.should be_nil
  end

  it "explains the codepoint limit for a slightly too long secret" do
    post "/create", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {ciphertext: "A" * 2_000, expires_in_seconds: 60}.to_json
    response.status_code.should eq 400
    response.body.should contain "Please reduce plaintext size."
  end

  it "rejects a request too large to hold a secret" do
    post "/create", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {ciphertext: "A" * 100_000, expires_in_seconds: 60}.to_json
    response.status_code.should eq 413
    response.body.should contain "Please reduce plaintext size."
  end

  it "rejects a request of unknown size" do
    process_request HTTP::Request.new("POST", "/create", HTTP::Headers{"Content-Type" => "application/json"}, IO::Memory.new({ciphertext: "A" * 2_000, expires_in_seconds: 60}.to_json))
    response.status_code.should eq 413
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
