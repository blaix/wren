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
end
