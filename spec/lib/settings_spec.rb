require "rails_helper"

describe Settings do
  subject { Settings }

  it "provides a value for amqp_uri" do
    expect(subject.amqp_uri).not_to eq nil
  end

  it "provides a value for worker_queue_prefix" do
    expect(subject.worker_queue_prefix).to eq "dc.dev.q."
  end
end
