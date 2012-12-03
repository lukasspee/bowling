require File.join(File.expand_path('..', File.dirname(__FILE__)), 'bowling')

describe "Bowling::Game" do

  describe "#score" do
    subject { Bowling::Game.new(scorecard).score }

    context "with only numbers in the scorecard" do
      let(:scorecard) { compact_score '17 24 36 52 63 24 62 55 81 43' }
      it { should == 79 }
    end

    context "with only dashes in the scorecard" do
      let(:scorecard) { '--' * 10 }
      it { should == 0 }
    end

    context "with numbers and dashes in the scorecard" do
      let(:scorecard) { compact_score '17 24 36 -2 63 24 62 -5 81 43' }
      it { should == 69 }
    end

    context "with spares in the scorecard" do
      let(:scorecard) { compact_score '17 24 36 52 63 24 62 55 8/ 43' }
      it { should == 84 }
    end

    context "with strikes in the scorecard" do
      let(:scorecard) { compact_score '17 24 36 52 63 24 62 55 X 43' }
      it { should == 87 }
    end

  end

  def compact_score(string)
    string.gsub(/\s+/, '')
  end

end