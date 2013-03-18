# encoding: utf-8

require "spec_helper"

describe Question do
  let(:answers_array) { [Answer.new(:overwrite), Answer.new(:abort)] }

  let(:question_msg) { "What to do?" }
  let(:question) { Question.new(question_msg) }
  subject { question }

  describe "#init" do
    its(:answers) { should be_kind_of Answers }
    its("answers.size") { should == 0  }
    its(:question) { should == question_msg }
  end

  describe "#answers=" do
    before { subject.answers = [:abort, :overwrite] }
    its(:answers) { should be_kind_of Answers }
    its("answers.size") { should == 2  }
  end

  describe "#ask" do
    it "should raise an error without answers" do
      expect { subject.ask }.to raise_error /have to set answers/
    end

    context "with answers" do
      before { subject.answers = answers_array }
      before do
        UserInput.should_receive(:get).with("#{question_msg} [o]verwrite, [a]bort").and_return("o")
      end
      its(:ask) { should == :overwrite }
    end
  end

  describe "::ask" do
    context "with answers as array" do
      subject { Question.ask(question_msg, [:all, :nothing]) }
      before do
        UserInput.should_receive(:get).with("#{question_msg} [A]ll, [n]othing").and_return("A")
      end
      it { should == :all }
    end
    context "with answers as hash" do
      subject { Question.ask(question_msg, all: true, nothing: true) }
      before do
        UserInput.should_receive(:get).with("#{question_msg} [A]ll, [n]othing").and_return("A")
      end
      it { should == :all }
    end
    context "with answers as hash with false value" do
      subject { Question.ask(question_msg, all: true, not: false, nothing: true) }
      before do
        UserInput.should_receive(:get).with("#{question_msg} [A]ll, [n]othing").and_return("A")
      end
      it { should == :all }
    end
  end
end
