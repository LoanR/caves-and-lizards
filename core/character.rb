# frozen_string_literal: true

require 'securerandom'

require_relative './random'
require_relative '../conf/conf'

class Character
  attr_reader :uuid, :initiative, :name, :race, :level, :order, :background, :abilities, :living_player, :team, :max_hit_points, :hit_points, :equipment, :inventory, :currently_dodging

  def initialize(**opts)
    validate!(opts: opts)
    @name, @race, @level, @order, @background, @abilities,
    @living_player, @team, @max_hit_points, @hit_points, @equipment,
    @inventory = opts.values_at(
      :name, :race, :level, :order, :background, :abilities,
      :living_player, :team, :max_hit_points, :max_hit_points, :equipment, :inventory
    )
    @uuid = SecureRandom.uuid
    @currently_dodging = false
    @initiative = 0
  end

  def attack_throw # why on character ? Always 1d20, need instance ? More like rule, yes ?
    dice(faces: 20)
  end

  def set_initiative(initiative:)
    @initiative = initiative
  end

  def ability_check(ability_str_id:)
    @abilities.modifier(ability_str_id: ability_str_id)
  end

  def attack_modifier
    ability_check(ability_str_id: relevant_ability_modifier_on_attack)
    # finesse
  end

  def relevant_ability_modifier_on_attack
    ABILITY_MODIFIER_CORRESPONDANCES[@equipment.main_hand.type]
  end

  def proficiency
    (@level - 1) / 4 + 2 # (level + 7) / 4 .floor
  end

  def armor_class
    @equipment.armor.base_armor_class + appliable_dexterity_bonus
    # shield
  end

  def appliable_dexterity_bonus
    dexterity_modifier = @abilities.modifier(ability_str_id: 'dexterity')
    max_dexterity_bonus = @equipment.armor.max_dexterity_bonus
    dexterity_bonus = 0
    if max_dexterity_bonus.nil? && dexterity_modifier >= 0
      dexterity_bonus = dexterity_modifier
    elsif !max_dexterity_bonus.nil? && max_dexterity_bonus.positive? && dexterity_modifier.positive?
      dexterity_bonus = [dexterity_modifier, max_dexterity_bonus].min
    end
    dexterity_bonus
  end

  def damage_throw
    weapon_damage = @equipment.get_weapon_damage
    damage = []
    weapon_damage[/^\d*/].to_i.times do
      damage << dice(faces: weapon_damage[/\d*$/].to_i)
    end
    damage
  end

  def suffers_damages!(damages:)
    @hit_points -= damages
    @hit_points.negative? && @hit_points = 0
  end

  def computed_damages(damages:) # on instance ? on character ?
    damages > 1 ? damages : 1
  end

  def starts_dodging!
    @currently_dodging = true
  end

  def stops_dodging!
    @currently_dodging = false
  end

  def equiped_weapons
    nil
  end

  private

  def validate!(opts:)
    errors = []
    errors << 'Missing name' if opts[:name].nil?
    errors << 'Missing character race object' if opts[:race].nil? # or opts[:race].kind_of?(Race)
    errors << 'Missing level' if opts[:level].nil?
    errors << 'Missing order' if opts[:order].nil?
    errors << 'Missing background' if opts[:background].nil?
    errors << 'Missing abilities' if opts[:abilities].nil?
    errors << 'Missing living_player' if opts[:living_player].nil?
    errors << 'Missing team' if opts[:team].nil?
    errors << 'Missing max_hit_points' unless opts[:max_hit_points].is_a? Integer
    errors << 'Missing equipment' if opts[:equipment].nil?
    errors << 'Missing inventory' if opts[:inventory].nil?
    raise ArgumentError, errors.join(' - ') unless errors.empty?
  end

  # def can_have_dexterity_bonus_armor_class?(:dexterity_modifier, :max_dexterity_bonus)
  #   dexterity_modifier > 0 && max_dexterity_bonus > 0
  # end
end
