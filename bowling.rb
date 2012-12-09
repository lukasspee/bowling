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
      frames[0..9].inject(0) do |r, frame|
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
      shots[0] + shots[1].to_i
    end

    def shots
      @shots ||= begin
        if text_value[0] == "X"
          [ 10 ]
        else
          first  = text_value[0].to_i
          second = text_value[1] == "/" ? 10 - first : text_value[1].to_i
          [ first, second ]
        end
      end
    end

    def next_frame
      i = parent.elements.index(self) + 1
      parent.elements[i]
    end

    def spare?
      text_value[1] == "/"
    end

    def strike?
      text_value[0] == "X"
    end

    def all_pins_down?
      strike? || spare?
    end

    def bonus
      if spare?
        next_frame.shots[0]
      elsif strike? && !next_frame.bonus? && next_frame.strike?
        next_frame.bare_score + next_frame.next_frame.shots[0]
      elsif strike?
        next_frame.bare_score
      else
        0
      end
    end

    def bonus?
      false
    end

  end

  module BonusFrame

    def bare_score
      shots[0] + shots[1].to_i
    end

    alias :score :bare_score

    def shots
      @shots ||= begin
        first = text_value[0] == "X" ? 10 : text_value[0].to_i
        shots = [ first ]
        if text_value[1]
          second = if text_value[1] == "X"
            10
          elsif text_value[1] == "/"
            10 - first
          else
            text_value[1].to_i
          end
          shots << second
        end
        shots
      end
    end

    def bonus?
      true
    end

  end

  class ParseError < StandardError; end
end