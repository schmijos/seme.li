require "spec-kemal"
require "../src/semel"

describe "Semel" do
  it "renders /" do
    get "/"
    response.body.should contain "Semel"
  end
end
