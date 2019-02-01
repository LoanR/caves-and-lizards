# frozen_string_literal: true

require_relative '../core/random'
require_relative '../run/player_interaction'
require_relative '../conf/actions'
require_relative '../conf/conf'
require_relative '../interface/message_builder'

class Combat
  attr_reader :involved_fighters, :dead_fighters

  def initialize(**opts)
    @involved_fighters = opts.values_at(:involved_fighters)[0]
    @dead_fighters = []
  end

  def resolve_initiative!
    @involved_fighters.each do |fighter|
      roll_initiative!(character: fighter)
    end
    @involved_fighters = arrange_turn_order(characters: @involved_fighters)
  end

  def roll_initiative!(character:)
    roll = dice(faces: 20)
    dexterity_check = character.ability_check(ability_str_id: 'dexterity')
    character.set_initiative(initiative: roll + dexterity_check)
    puts MessageBuilder.format_roll_message(
      roll: " initiative: #{character.initiative}",
      rule: ' 1d20 + dexterity check',
      calculation: " #{roll} + #{dexterity_check}",
      character: character
    )
    # equality cases?
  end

  def arrange_turn_order(characters:)
    characters.sort_by { |fighter| -fighter.initiative }
  end

  def round_sequence
    @involved_fighters.each do |active_character|
      next if dead_character_or_no_ennemies(character: active_character)

      if active_character.living_player
        puts MessageBuilder.format_according_to_character(
          character: active_character,
          to_format: active_character.name,
          formatting: 'name_formatting'
        )
      else
        print MessageBuilder.format_according_to_character(
          character: active_character,
          to_format: active_character.name,
          formatting: 'name_formatting'
        )
      end
      active_character.currently_dodging && active_character.stops_dodging!
      choose_and_execute_action(character: active_character)
    end
  end

  def dead_character_or_no_ennemies(character:)
    character.hit_points <= 0 || count_involved_teams <= 1
  end

  def count_involved_teams
    @involved_fighters.map(&:team).uniq.length
  end

  def choose_and_execute_action(character:)
    command = select_character_action(character: character)
    sleep(0.3)
    send(COMBAT_ACTION_COMMANDS[command], character: character)
    puts "\n"
    sleep(1)
  end

  def select_character_action(character:)
    if character.living_player
      PlayerInteraction.new(
        question: OUTPUT_INDENT + 'What do you want to do?',
        choices: COMBAT_ACTIONS_CHOICES,
        identifiers: COMBAT_ACTION_IDENTIFIERS
      ).ask_for_hero_action
    else
      COMBAT_ACTION_COMMANDS.keys.sample
    end
  end

  def select_and_attack_target(character:)
    defender = choose_target(character: character)
    enemy_name = MessageBuilder.format_according_to_character(
      character: defender,
      to_format: defender.name,
      formatting: 'name_formatting'
    )
    if character.living_player
      print MessageBuilder.format_according_to_character(
        character: character,
        to_format: character.name,
        formatting: 'name_formatting'
      )
    end
    puts " attacks #{enemy_name}"
    sleep(0.8)

    resolve_attack(attacker: character, defender: defender)
    @involved_fighters = select_living_fighters
  end

  def choose_target(character:)
    enemies = select_potential_targets(character: character)
    designate_target(enemies: enemies, character: character)
  end

  def select_potential_targets(character:)
    @involved_fighters.reject { |fighter| fighter.team == character.team }
  end

  def designate_target(enemies:, character:)
    if character.living_player
      ask_player_for_target(enemies: enemies, character: character)
    else
      enemies.sample
    end
  end

  def ask_player_for_target(enemies:, character:)
    target_choices, target_identifiers = prepare_player_target_selection(enemies: enemies)
    puts MessageBuilder.format_according_to_character(
      character: character,
      to_format: character.name,
      formatting: 'name_formatting'
    )
    selected_enemy_uuid = PlayerInteraction.new(
      question: OUTPUT_INDENT + 'Who do you want to attack?',
      choices: target_choices,
      identifiers: target_identifiers
    ).ask_for_hero_action

    enemies.find do |enemy|
      enemy.uuid == selected_enemy_uuid
    end
  end

  def prepare_player_target_selection(enemies:)
    target_choices = []
    target_identifiers = {}
    max_max_hp = enemies.map(&:max_hit_points).max # as instance var ?
    max_name_length = @involved_fighters.map { |fighter| fighter.name.size }.max # as instance var ?
    enemies.each_with_index do |enemy, index|
      target_choices << format_enemy_selection_data_question(
        enemy: enemy,
        index: index,
        max_max_hp: max_max_hp,
        max_name_length: max_name_length
      )
      target_identifiers[enemy.uuid] = [(index + 1).to_s, enemy.name]
    end
    [target_choices, target_identifiers]
  end

  def format_enemy_selection_data_question(enemy:, index:, max_max_hp:, max_name_length:)
    OUTPUT_INDENT + "#{index + 1}: " + "#{enemy.name} ".ljust(max_name_length + 1, '.') +
      format_health_bar(character: enemy, max_max_hp: max_max_hp) +
      " #{enemy.currently_dodging ? MessageBuilder.format_state(state: 'dodging') : ''}"
  end

  def format_health_bar(character:, max_max_hp:, damages: 0)
    if character.hit_points > 0
      health_bar = " #{character.hit_points.to_s}/#{character.max_hit_points}hp"
    else
      health_bar = ' ♱'
    end
    if character.hit_points > 0
      health_bar = health_bar.ljust((30 * character.max_hit_points / max_max_hp).round) # 30 space magic
      filled_bar = health_bar.slice!(0, (30.to_f * character.hit_points / max_max_hp).ceil) # 30 space magic
      lost_bar = health_bar.slice!(0, (30.to_f * damages / max_max_hp).ceil) # 30 space magic
      MessageBuilder.format_filled_health_bar(character: character, bar: filled_bar) +
        MessageBuilder.format_lost_health_bar(character: character, bar: lost_bar) +
        MessageBuilder.format_empty_health_bar(character: character, bar: health_bar)
    else
      health_bar
    end
  end

  def resolve_attack(attacker:, defender:)
    modifier = attacker.attack_modifier
    attack_throws = attack_dice(attacker: attacker, defender: defender)
    attack_roll = perform_attack(attacker: attacker, defender: defender, attack_throws: attack_throws, modifier: modifier)
    sleep(0.3)

    if attack_roll >= defender.armor_class
      carry_damages(attacker: attacker, defender: defender, modifier: modifier)
    else
      miss_hit(attacker: attacker, defender: defender, attack_throws: attack_throws, modifier: modifier)
    end
  end

  def perform_attack(attacker:, defender:, modifier:, attack_throws:)
    # critical hits critical failures ?
    proficiency_bonus = attacker.proficiency
    attack_roll = attack_throws.min + modifier + proficiency_bonus

    attack_throw_msg = attack_throws.join(' or ')
    puts format_attack(attack_roll: attack_roll, attacker: attacker, defender: defender, attack_throw_msg: attack_throw_msg, modifier: modifier, proficiency_bonus: proficiency_bonus)
    attack_roll
  end

  def attack_dice(attacker:, defender:)
    values = [attacker.attack_throw]
    defender.currently_dodging && values << attacker.attack_throw
    values
  end

  def format_attack(attack_roll:, attacker:, defender:, attack_throw_msg:, modifier:, proficiency_bonus:)
    MessageBuilder.format_roll_message(
      roll: " attack: #{attack_roll} against armor class #{defender.armor_class}",
      rule: " 1d20 + #{attacker.relevant_ability_modifier_on_attack} modifier + proficiency ⋮ #{defender.equipment.armor.name} + applicable dexterity bonus",
      calculation: " #{attack_throw_msg} + #{modifier} + #{proficiency_bonus} ⋮ #{defender.equipment.armor.base_armor_class} + #{defender.appliable_dexterity_bonus}",
      disadvantage: defender.currently_dodging
    )
  end

  def carry_damages(attacker:, defender:, modifier:)
    puts MessageBuilder.character_action_message(doer: attacker, bearer: defender, success: 'hits')
    damage_roll = attacker.damage_throw
    total_damage = attacker.computed_damages(damages: damage_roll.reduce(:+) + modifier)
    sleep(0.8)

    puts MessageBuilder.format_roll_message(
      roll: " damage: #{total_damage}",
      rule: " #{attacker.equipment.main_hand.name}'s #{attacker.equipment.get_weapon_damage} + #{attacker.relevant_ability_modifier_on_attack} modifier",
      calculation: " (#{damage_roll.join(' + ')}) + #{modifier}"
    )
    sleep(0.3)

    defender.suffers_damages!(damages: total_damage)
    puts MessageBuilder.format_damage_taken(character: defender, damages: total_damage)
    puts "\n"
    max_max_hp = @involved_fighters.map(&:max_hit_points).max # as instance var ?
    max_name_length = @involved_fighters.map { |fighter| fighter.name.size }.max # as instance var ?
    @involved_fighters.each do |fighter|
      if fighter == defender
        health_bar = OUTPUT_INDENT + MessageBuilder.format_according_to_character(character: fighter, to_format: (fighter.name  + ': ').ljust(max_name_length + 2, '.'), formatting: 'fail_formatting')
        health_bar += format_health_bar(character: fighter, max_max_hp: max_max_hp, damages: total_damage)
      else
        health_bar = OUTPUT_INDENT + (fighter.name + ': ').ljust(max_name_length + 2, '.') + format_health_bar(character: fighter, max_max_hp: max_max_hp)
      end
      puts health_bar
    end
  end

  def miss_hit(attacker:, defender:, attack_throws:, modifier:)
    missed_msg = MessageBuilder.character_action_message(doer: attacker, bearer: defender, failed: 'missed')
    if defender.currently_dodging && attack_throws.max + modifier + attacker.proficiency >= defender.armor_class
      missed_msg += MessageBuilder.character_action_message(doer: defender, success: 'dodged', subject: false)
    end
    puts missed_msg
  end

  def select_living_fighters
    @involved_fighters.reject do |fighter|
      if fighter.hit_points <= 0
        @dead_fighters << fighter
        puts "\n"
        puts OUTPUT_INDENT + "♱ #{fighter.name} ♱ died!"
      end
      fighter.hit_points <= 0
    end
  end

  def dodge_until_next_turn(character:)
    if character.living_player
      print MessageBuilder.format_according_to_character(
        character: character,
        to_format: character.name,
        formatting: 'name_formatting'
      )
    end
    puts ' tries to ' + MessageBuilder.format_state(state: 'dodge') + '.'
    character.starts_dodging!
  end
end
