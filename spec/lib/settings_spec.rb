require "rails_helper"

describe Settings do
  subject { Settings }

  it "provides a value for amqp_uri" do
    expect(subject.amqp_uri).not_to eq nil
  end

  it "provides a value for worker_queue_prefix" do
    expect(subject.worker_queue_prefix).to eq "dc.dev.q."
  end

  it "provides a value for request_exchange_name" do
    expect(subject.request_exchange_name).to eq "dc.dev.e.fanout.requests"
  end

  it "provides a value for request_exchange_options" do
    expect(subject.request_exchange_options).to eq({:durable => true, :type => "fanout"})
  end

  it "provides a value for reporting_exchange_name" do
    expect(subject.reporting_exchange_name).to eq "dc.dev.e.topic.reporting"
  end

  it "provides a value for reporting_exchange_options" do
    expect(subject.reporting_exchange_options).to eq({:durable => true, :type => "topic"})
  end
end
