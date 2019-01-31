# frozen_string_literal: true

require 'colorize'

class OutputColor
  def self.hero_name(msg:)
    msg.green.underline
  end

  def self.enemy_name(msg:)
    msg.red.underline
  end

  def self.enemy_fail(msg:)
    msg.red
  end

  def self.hero_fail(msg:)
    msg.light_red
  end

  def self.disadvantage(msg:)
    msg.red
  end

  def self.enemy_succeed(msg:)
    msg.green
  end

  def self.hero_succeed(msg:)
    msg.light_green
  end

  def self.advantage(msg:)
    msg.green
  end

  def self.common_item(msg:)
    msg.white
  end

  def self.rare_item(msg:)
    msg.blue
  end

  def self.very_rare_item(msg:)
    msg.magenta
  end

  def self.legendary_item(msg:)
    msg.light_yellow
  end

  def self.log(msg:)
    msg.white
  end

  def self.log_rule(msg:)
    msg.light_black
  end

  def self.damage_on_enemy(msg:)
    msg.black.on_red
  end

  def self.empty_health_bar(msg:)
    msg.black.on_red
  end

  def self.filled_health_bar(msg:)
    msg.black.on_green
  end

  def self.empty_hero_health_bar(msg:)
    msg.black.on_light_red
  end

  def self.filled_hero_health_bar(msg:)
    msg.black.on_light_green
  end

  def self.damage_on_hero(msg:)
    msg.black.on_light_red
  end

  def self.damage_from_hero(msg:)
    msg.black.on_light_green
  end

  def self.state(msg:)
    msg.yellow
  end
end
