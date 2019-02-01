# frozen_string_literal: true

require_relative '../conf/actions'
require_relative '../conf/conf'

class PlayerInteraction
  def initialize(**opts)
    @question, @choices, @identifiers = opts.values_at(
      :question, :choices, :identifiers
    )
    @player_input = nil
  end

  def ask_for_hero_action
    while @player_input.nil?
      @player_input = ask_for_input
      if corresponding_input_key.nil?
        @player_input = nil
        puts 'You must select one of the possibilities!'
      end
    end
    corresponding_input_key
  end

  private

  def ask_for_input
    puts @question
    lines = 3
    @choices.each do |choice|
      lines += 1
      puts choice
    end
    print OUTPUT_INDENT
    input = gets.strip
    print "\e[A\e[2K" * lines
    input
  end

  def corresponding_input_key
    @identifiers.select { |_k, v| v.include? @player_input }.keys.first
  end
end
