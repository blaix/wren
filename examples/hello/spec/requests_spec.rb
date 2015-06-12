require "rack/mock"

require "hello/app"
require "spec_helper"

describe Hello::App do
  let(:request) { Rack::MockRequest.new(subject) }

  describe "GET /hello" do
    let!(:response) { request.get("/hello") }

    it "says hello to the world" do
      expect(response.body).to eq("Hello, World!")
    end

    it "gives a successful response" do
      expect(response).to be_ok
    end
  end

  describe "GET to a non-existant path" do
    let!(:response) { request.get("/path/that/does/not/exist") }

    it "404s" do
      expect(response).to be_not_found
    end
  end

  describe "HTTP method not supported by a resource" do
    it "404s" do
      expect(request.post("/hello")).to be_not_found
      expect(request.put("/world")).to be_not_found
    end
  end

  describe "DELETE /world" do
    let!(:response) { request.delete("/world") }

    it "says goodbye to the world" do
      expect(response.body).to eq("Goodbye, World!")
    end

    it "gives a successful response" do
      expect(response).to be_ok
    end
  end
end
