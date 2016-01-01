require "hello/actions/say_hello"

describe SayHello do
  it "says hello to the world" do
    expect(subject.call).to eq("Hello, World!")
  end
end
