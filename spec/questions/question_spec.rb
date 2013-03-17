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
        subject.should_receive(:gets).with("#{question_msg} [o]verwrite, [a]bort").and_return("o")
      end
      its(:ask) { should == :overwrite }
    end
  end

  describe "::ask" do
    context "with answers as array" do
      subject { Question.ask(question_msg, [:all, :nothing]) }
      before do
        Question.any_instance.should_receive(:gets).with("#{question_msg} [A]ll, [n]othing").and_return("A")
      end
      it { should == :all }
    end
    context "with answers as hash" do
      subject { Question.ask(question_msg, all: true, nothing: true) }
      before do
        Question.any_instance.should_receive(:gets).with("#{question_msg} [A]ll, [n]othing").and_return("A")
      end
      it { should == :all }
    end
    context "with answers as hash with false value" do
      subject { Question.ask(question_msg, all: true, not: false, nothing: true) }
      before do
        Question.any_instance.should_receive(:gets).with("#{question_msg} [A]ll, [n]othing").and_return("A")
      end
      it { should == :all }
    end
  end

  describe "Privates:" do
    describe "#gets" do
      before do
        STDOUT.should_receive(:print).with(question_msg + " ")
        STDOUT.should_receive(:flush)
        STDIN.should_receive(:gets).and_return("y\n")
      end
      it { subject.send(:gets, question_msg).should == "y" }
    end
  end
end
