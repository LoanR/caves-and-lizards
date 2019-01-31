# frozen_string_literal: true

class Abilities
  attr_reader :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma

  def initialize(**opts)
    @strength, @dexterity, @constitution, @intelligence,
    @wisdom, @charisma = opts.values_at(
      :strength, :dexterity, :constitution, :intelligence,
      :wisdom, :charisma
    )
  end

  def modifier(ability_str_id:)
    instance_variable_get('@' + ability_str_id) / 2 - 5
  end
end
