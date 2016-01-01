require "hello/actions/say_goodbye"

describe SayGoodbye do
  it "says goodbye to the world" do
    expect(subject.call).to eq("Goodbye, World!")
  end
end
