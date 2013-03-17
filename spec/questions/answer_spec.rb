# encoding: utf-8

require "spec_helper"

describe :Answer do
  shared_examples_for 'a true answer' do
    its(:active?) { should be_true }
    its(:inactive?) { should be_false }
    its(:true?) { should be_true }
    its(:false?) { should be_false }
    its(:indicator) { should_not be_nil }
    its(:instruction) { should_not == "" }
  end

  shared_examples_for 'a true normal answer' do
    it_should_behave_like 'a true answer'
    its(:instruction) { should == :overwrite }
    its(:indicator_hash) { should == {:o => :overwrite} }
    its(:to_s) { should == "[o]verwrite" }
    its(:special?) { should be_false }

    its(:indicator) { should == :o }
    describe "indicator" do
      it "#indicator(2) == :ov" do
        subject.indicator(2) == :ov
      end
      it "#indicator(3) == :ove" do
        subject.indicator(3) == :ove
      end
    end
  end

  shared_examples_for 'a true special answer' do
    it_should_behave_like 'a true answer'
    its(:instruction) { should == :overwrite_all }
    its(:indicator_hash) { should == {:O => :overwrite_all} }
    its(:to_s) { should == "[O]verwrite all" }
    its(:special?) { should be_true }

    its(:indicator) { should == :O }
    describe "indicator" do
      it "#indicator(2) == :OV" do
        subject.indicator(2) == :OV
      end
      it "#indicator(3) == :OVE" do
        subject.indicator(3) == :OVE
      end
    end
  end

  shared_examples_for 'a false answer' do
    its(:active?) { should be_false }
    its(:inactive?) { should be_true }
    its(:true?) { should be_false }
    its(:false?) { should be_true }
    its(:indicator) { should be_nil }
    its(:instruction) { should == :overwrite }
    its(:indicator_hash) { should be_nil }
    its(:to_s) { should == nil }
  end

  describe "#initialize" do
    # true normal
    context "with true as value" do
      context "with braces" do
        subject { Answer.new({:overwrite => true}) }
        it_should_behave_like 'a true normal answer'
      end
      context "without braces" do
        subject { Answer.new(:overwrite => true) }
        it_should_behave_like 'a true normal answer'
      end
    end
    context "as symbol" do
      subject { Answer.new(:overwrite) }
      it_should_behave_like 'a true normal answer'
    end

    # true special
    context "with true as value" do
      context "with braces" do
        subject { Answer.new({:overwrite_all => true}) }
        it_should_behave_like 'a true special answer'
      end
      context "without braces" do
        subject { Answer.new(:overwrite_all => true) }
        it_should_behave_like 'a true special answer'
      end
    end
    context "as symbol" do
      subject { Answer.new(:overwrite_all) }
      it_should_behave_like 'a true special answer'
    end

    # false
    context "with false as value" do
      context "with braces" do
        subject { Answer.new({:overwrite => false}) }
        it_should_behave_like 'a false answer'
      end
      context "without braces" do
        subject { Answer.new(:overwrite => false) }
        it_should_behave_like 'a false answer'
      end
    end
    context "with nil as value" do
      subject { Answer.new(:overwrite => nil) }
      it_should_behave_like 'a false answer'
    end
  end

  describe "#indicator=" do
    subject { Answer.new(:overwrite) }
    its(:indicator) { should == :o }
    it "should set indicator" do
      subject.indicator = :ov
      subject.indicator.should == :ov
    end
  end
end
