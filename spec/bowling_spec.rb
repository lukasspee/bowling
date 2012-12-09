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

    context "with a strike followed by a spare in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- X -/ --' }
      it { should == 30 }
    end

    context "with a spare followed by a strike in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -/ X --' }
      it { should == 30 }
    end

    context "with a strike followed by another strike in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- X X 5-' }
      it { should == 45 }
    end

    context "with a turkey in the scorecard (three strikes)" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- X X X --' }
      it { should == 60 }
    end

    context "with a bonus frame following a spare in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- -/ 5' }
      it { should == 15 }
    end

    context "with a bonus frame following a strike in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- X 5-' }
      it { should == 15 }
    end

    context "with a bonus strike following a spare in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- -/ X' }
      it { should == 20 }
    end

    context "with a bonus spare in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- X -/' }
      it { should == 20 }
    end

    context "with a bonus strike following a strike in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- X X-' }
      it { should == 20 }
    end

    context "with two bonus strikes in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- X XX' }
      it { should == 30 }
    end

    context "with a bonus strike plus 5 in the scorecard" do
      let(:scorecard) { compact_score '-- -- -- -- -- -- -- -- -- X X5' }
      it { should == 25 }
    end

    context "a perfect game" do
      let(:scorecard) { compact_score 'X X X X X X X X X X XX' }
      it { should == 300 }
    end
  end

  def compact_score(string)
    string.gsub(/\s+/, '')
  end

end