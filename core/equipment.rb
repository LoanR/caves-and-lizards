# frozen_string_literal: true

class Equipment
  attr_reader :armor, :left_hand_ring, :right_hand_ring, :amulet, :helmet, :cloak, :gloves, :bracers, :belt, :boots, :main_hand, :off_hand

  def initialize(**opts)
    @armor, @left_hand_ring, @right_hand_ring, @amulet, @helmet, @cloak,
    @gloves, @bracers, @belt, @boots, @main_hand, @off_hand = opts.values_at(
      :armor, :left_hand_ring, :right_hand_ring, :amulet, :helmet, :cloak,
      :gloves, :bracers, :belt, :boots, :main_hand, :off_hand
    )
  end

  def active_weapons
    nil
  end

  def get_weapon_damage
    @main_hand.damage
  end
end
