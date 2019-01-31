# frozen_string_literal: true

require_relative './output_color'

class MessageBuilder
  def self.format_roll_message(roll:, rule:, advantage: false, disadvantage: false, character: nil)
    log = OutputColor.log(msg: ' rolls' + roll + ' ∴')
    adv = advantage ? OutputColor.advantage(msg: ' advantage') : ''
    disadv = disadvantage ? OutputColor.disadvantage(msg: ' disadvantage') : ''
    rule_log = adv + disadv + OutputColor.log_rule(msg: rule)

    (character ? format_according_to_character(character: character, to_format: character.name, formatting: 'name_formatting') : OutputColor.log(msg: '    ➺ ')) + log + rule_log
  end

  def self.format_according_to_character(character:, to_format:, formatting:)
    OutputColor.send(send(formatting, character: character), msg: to_format)
  end

  def self.format_damage_taken(character:, damages:)
    char = format_according_to_character(character: character, to_format: character.name, formatting: 'name_formatting')
    dmg = format_according_to_character(character: character, to_format: damages.to_s + ' damages', formatting: 'damage_formatting')
    remains = format_according_to_character(character: character, to_format: character.hit_points.to_s + ' hit points', formatting: 'damage_formatting')
    "  #{char} took #{dmg} and is now at #{remains}..."
  end

  def self.format_state(state:)
    OutputColor.state(msg: state)
  end

  def self.format_empty_health_bar(character:, bar:)
    format_according_to_character(character: character, to_format: bar, formatting: 'empty_health_bar_formatting') unless bar.nil?
  end

  def self.format_filled_health_bar(character:, bar:)
    format_according_to_character(character: character, to_format: bar, formatting: 'filled_health_bar_formatting') unless bar.nil?
  end

  def self.name_formatting(character:)
    character.living_player ? 'hero_name' : 'enemy_name'
  end

  def self.fail_formatting(character:)
    character.living_player ? 'hero_fail' : 'enemy_fail'
  end

  def self.success_formatting(character:)
    character.living_player ? 'hero_succeed' : 'enemy_succeed'
  end

  def self.damage_formatting(character:)
    character.living_player ? 'damage_on_hero' : 'damage_on_enemy'
  end

  def self.empty_health_bar_formatting(character:)
    character.living_player ? 'empty_hero_health_bar' : 'empty_health_bar'
  end

  def self.filled_health_bar_formatting(character:)
    character.living_player ? 'filled_hero_health_bar' : 'filled_health_bar'
  end

  def self.character_action_message(doer: nil, bearer: nil, success: nil, failed: nil, subject: true)
    done = success ? format_according_to_character(character: doer, to_format: success, formatting: 'success_formatting') : ''
    miss = failed ? format_according_to_character(character: doer, to_format: failed, formatting: 'fail_formatting') : ''
    if !subject
      doer_name = doer && success ? format_according_to_character(character: doer, to_format: doer.name, formatting: 'name_formatting') + ' ' : ''
      bearer_name = bearer && failed ? ' ' + format_according_to_character(character: bearer, to_format: bearer.name, formatting: 'name_formatting') : ''
    else
      doer_name = doer && failed ? format_according_to_character(character: doer, to_format: doer.name, formatting: 'name_formatting') + ' ' : ''
      bearer_name = bearer && success ? ' ' + format_according_to_character(character: bearer, to_format: bearer.name, formatting: 'name_formatting') : ''
    end
    '  ' + doer_name + done + miss + bearer_name + (success ? '!' : '...')
  end
end
