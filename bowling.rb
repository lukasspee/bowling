require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Treetop.load('./lib/score_grammar')

module Bowling
  class Game
    @@parser = Bowling::ScoreParser.new
    attr_reader :frames

    def initialize(scorecard)
      tree = @@parser.parse( scorecard.upcase )
      raise ParseError, "Not a valid bowling scorecard" if tree.nil?
      @frames = tree.elements
    end

    def score
      frames.inject(0) do |r, frame|
        r += frame.score
        r
      end
    end
  end

  module Frame

    def score
      bare_score + bonus
    end

    def bare_score
      all_pins_down? ? 10 : (throws[0].to_i + throws[1].to_i)
    end

    def throws
      [text_value[0], text_value[1]].compact
    end

    def next_frame
      i = parent.elements.index(self) + 1
      parent.elements[i]
    end

    def spare?
      throws[1] == '/'
    end

    def strike?
      throws[0] == 'X'
    end

    def all_pins_down?
      strike? || spare?
    end

    def bonus
      if spare?
        next_frame.throws[0].to_i
      elsif strike?
        next_frame.bare_score
      else
        0
      end
    end

  end

  class ParseError < StandardError; end
end