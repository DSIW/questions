# encoding: utf-8

require "spec_helper"

describe Answers do
  let(:overwrite) { Answer.new(:overwrite) }
  let(:no_overwrite) { Answer.new(:overwrite => false) }

  let(:abort) { Answer.new(:abort) }
  let(:no_abort) { Answer.new(:abort => false) }

  let(:answers_array) { [overwrite, abort] }
  let(:answers_array_with_false) { [overwrite, no_abort] }

  let(:answers_hash) { {overwrite: true, abort: true} }
  let(:answers_hash_with_false) { {overwrite: true, abort: false} }

  shared_examples_for "one answer" do
    its(:size) { should == 1 }
    its(:first) { should == abort }
  end

  shared_examples_for "one symbol" do
    its(:size) { should == 1 }
    its(:first) { should be_kind_of Answer }
    its("first.instruction") { should == :abort }
  end

  shared_examples_for "two answers" do
    its(:size) { should == 2 }
    it "each answer should be kind of Answer" do
      subject.all? { |answer| answer.kind_of? Answer }
    end
    its("first.instruction") { should == :overwrite }
    its("last.instruction") { should == :abort }
  end

  shared_examples_for "hash with two true items" do
    its(:size) { should == 2 }
    it "each answer should be kind of Answer" do
      subject.all? { |answer| answer.kind_of? Answer }
    end
    it "should be :overwrite and :abort" do
      subject.map(&:instruction).should == [:overwrite, :abort]
    end
    it "each answer should be true" do
      subject.map(&:true?).should == [true, true]
    end
  end

  shared_examples_for "hash with one true and one false item" do
    its(:size) { should == 2 }
    it "each answer should be kind of Answer" do
      subject.all? { |answer| answer.kind_of? Answer }
    end
    it "should be :overwrite and :abort" do
      subject.map(&:instruction).should == [:overwrite, :abort]
    end
    it "should be true and false" do
      subject.map(&:true?).should == [true, false]
    end
  end

  describe "#init" do
    context "when parameter is Answer" do
      subject { Answers.new(abort) }
      include_examples "one answer"
    end
    context "when parameter is Symbol" do
      subject { Answers.new(:abort) }
      include_examples "one symbol"
    end

    context "when parameter is array" do
      subject { Answers.new(answers_array) }
      include_examples "two answers"
    end
    context "when parameter is array filled with symbols" do
      subject { Answers.new([:overwrite, :abort]) }
      include_examples "two answers"
    end
    context "mixed array filled with symbols and answers" do
      subject { Answers.new([:overwrite, abort]) }
      include_examples "two answers"
    end

    context "when parameter is Hash with true values" do
      subject { Answers.new(answers_hash) }
      include_examples "hash with two true items"
    end
    context "when parameter is Hash with value false" do
      subject { Answers.new(answers_hash_with_false) }
      include_examples "hash with one true and one false item"
    end
  end

  describe "#<<" do
    subject { Answers.new }

    context "when parameter is Answer" do
      before { subject << abort }
      include_examples "one answer"
    end
    context "when parameters are Answers with chaining" do
      before { subject << overwrite << abort }
      include_examples "two answers"
    end
    context "when parameter is Symbol" do
      before { subject << :abort }
      include_examples "one symbol"
    end

    context "when parameter is array" do
      before { subject << answers_array }
      include_examples "two answers"
    end
    context "when parameter is array filled with symbols" do
      before { subject << [:overwrite, :abort] }
      include_examples "two answers"
    end
    context "mixed array filled with symbols and answers" do
      before { subject << [:overwrite, abort] }
      include_examples "two answers"
    end

    context "when parameter is Hash with true values" do
      before { subject << answers_hash }
      include_examples "hash with two true items"
    end
    context "when parameter is Hash with value false" do
      before { subject << answers_hash_with_false }
      include_examples "hash with one true and one false item"
    end
  end

  describe "#update_indicators_for_uniqueness!" do
    before { subject << [:abort, :abort_all, :abc] }
    before { subject.send(:update_indicators_for_uniqueness!) }
    let(:indicators) { subject.map(&:indicator) }
    it "indicators should == [:a, :A, :ab]" do
      indicators.should == [:a, :A, :ab]
    end
    it "indicators should only exist unique answers" do
      indicators.should == indicators.uniq
    end
  end

  describe "#[]" do
    before { subject << [:abort, :abort_all, :abc] }
    it "should select answer by indicator" do
      subject[:a].indicator.should == :a
      subject[:a].instruction.should == :abort

      subject[:A].indicator.should == :A
      subject[:A].instruction.should == :abort_all
    end
  end

  describe "#have_unique_indicators?" do
    before { subject << [:abort, :abort_all, :abc] }
    it { should_not have_unique_indicators }
    context "after updating indicators for uniqueness" do
      before { subject.update_indicators_for_uniqueness! }
      it { should have_unique_indicators }
    end
  end

  describe "#indicators" do
    before { subject << [:abort, :abort_all, :abc] }
    its(:indicators) { should == [:a, :A, :a] }
    context "after updating indicators for uniqueness" do
      before { subject.update_indicators_for_uniqueness! }
      its(:indicators) { should == [:a, :A, :ab] }
    end
  end

  describe "#to_s" do
    context "all true" do
      before { subject << [:abort, :abort_all, :abc] }
      its(:to_s) { should == "[a]bort, [A]bort all, [ab]c" }
    end
    context "with false value" do
      before { subject << {abort: true, abort_all: false, abc: true} }
      its(:to_s) { should == "[a]bort, [ab]c" }
    end
  end

  describe "Private:" do
    describe "#select_symbols" do
      let(:hash) { {"abc" => true, abort: true, overwrite: false} }
      it "should return {abort: true, overwrite: false}" do
        subject.send(:select_symbols, hash).should == { abort: true, overwrite: false }
      end
    end

    describe "#convert_hash_to_answers" do
      let(:hash) { {abort: true, overwrite: false} }
      subject do
        Answers.new.send(:convert_hash_to_answers, hash)
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
        Answers.new.send(:convert_symbol_to_answer_or_send_through, parameter)
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
          subject.send(:free_indicator_of, abort, :used_indicators => [:b]).should == :a
        end

        it "should return :a if :used_indicators is empty" do
          subject.send(:free_indicator_of, abort, :used_indicators => []).should == :a
        end

        it "should return :a if no :used_indicators is set" do
          subject.send(:free_indicator_of, abort).should == :a
        end

        it "should reuturn :ab if :a is used" do
          subject.send(:free_indicator_of, abort, :used_indicators => [:a]).should == :ab
        end

        it "should return :ab if :a and :A is used" do
          subject.send(:free_indicator_of, abort, :used_indicators => [:a, :A]).should == :ab
        end
      end
    end
  end
end
