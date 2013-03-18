# encoding: utf-8

require "spec_helper"

describe AnswersHelper do
  let(:abort) { Answer.new(:abort) }

  describe "#select_symbols" do
    let(:hash) { {"abc" => true, abort: true, overwrite: false} }
    it "should return {abort: true, overwrite: false}" do
      AnswersHelper.select_symbols(hash).should == { abort: true, overwrite: false }
    end
  end

  describe "#convert_hash_to_answers" do
    let(:hash) { {abort: true, overwrite: false} }
    subject do
      AnswersHelper.convert_hash_to_answers(hash)
    end
    it "each entry should be kind of Answer" do
      subject.all? { |answer| answer.kind_of? Answer }
    end
    its("first.instruction") { should == :abort }
    its("first.true?") { should be_true }
    its("last.instruction") { should == :overwrite }
    its("last.true?") { should be_false }
  end

  describe "#convert_symbol_to_answer_or_send_through" do
    subject do
      AnswersHelper.convert_symbol_to_answer_or_send_through(parameter)
    end
    context "when parameter is a Symbol" do
      let(:parameter) { :abort }
      it { should be_kind_of Answer }
      its(:instruction) { should == :abort }
    end
    context "when parameter is an answer" do
      let(:parameter) { abort }
      it { should == abort }
    end
    context "when parameter is an other object" do
      let(:parameter) { "string" }
      it "should raise an ArgumentError" do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe "#free_indicator_of" do
    context ":abc" do
      it "should return :a if it isn't already used" do
        AnswersHelper.free_indicator_of(abort, :used_indicators => [:b]).should == :a
      end

      it "should return :a if :used_indicators is empty" do
        AnswersHelper.free_indicator_of(abort, :used_indicators => []).should == :a
      end

      it "should return :a if no :used_indicators is set" do
        AnswersHelper.free_indicator_of(abort).should == :a
      end

      it "should reuturn :ab if :a is used" do
        AnswersHelper.free_indicator_of(abort, :used_indicators => [:a]).should == :ab
      end

      it "should return :ab if :a and :A is used" do
        AnswersHelper.free_indicator_of(abort, :used_indicators => [:a, :A]).should == :ab
      end
    end
  end
end
