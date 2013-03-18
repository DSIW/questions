# encoding: utf-8

require "spec_helper"

describe UserInput do
  describe "#get" do
    let(:msg) { "What?" }
    before do
      STDOUT.should_receive(:print).with(msg + " ")
      STDOUT.should_receive(:flush)
      STDIN.should_receive(:gets).and_return("y\n")
    end
    it { subject.send(:get, msg).should == "y" }
  end
end
