# frozen_string_literal: true

class Armor
  attr_reader :name, :base_armor_class, :max_dexterity_bonus, :armor_check_penalty, :spell_failure, :feats_requirements

  def initialize(**opts)
    @name, @base_armor_class, @max_dexterity_bonus, @armor_check_penalty,
    @spell_failure, @feats_requirements = opts.values_at(
      :name, :base_armor_class, :max_dexterity_bonus, :armor_check_penalty,
      :spell_failure, :feats_requirements
    )
  end
end
